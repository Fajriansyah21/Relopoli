-- PropertyFlow (server-only): handler Landing untuk tile Property + intent client (PropertyAction).
-- Unowned -> Buy UI (L1/L2/L3) | Own -> Upgrade UI | Other -> Rent -> (L1-L4) Buy UI.
-- UI hanya memblokir Resolution Chain; Turn Controller tetap pemilik Turn.
-- Tidak ada timeout Buy/Upgrade UI di dokumen: menunggu keputusan (Cancel / Confirm). Pemain keluar / Game End = batal.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Constants = require(RS.Modules.Constants)
local BoardConfig = require(RS.Modules.BoardConfig)
local PropertyData = require(RS.Modules.PropertyData)
local GameState = require(SSS.Core.GameState)
local Economy = require(SSS.Core.Economy)
local TurnController = require(SSS.Core.TurnController)
local LandingResolver = require(SSS.Core.LandingResolver)
local PropertyService = require(SSS.Core.PropertyService)
local Liquidation = require(SSS.Core.Liquidation)
local ModifierService = require(SSS.Core.ModifierService)

local Result = Constants.Result

local PropertyFlow = {}

local pending = {} -- [userId] = { id, kind, tile, event }
local promptSeq = 0
local landingSeq = 0
local extraKinds = {} -- kind prompt tambahan dari sistem lain (Crown, Reward): { fn, allowCancel }

local function send(name, player, payload)
	local remotes = RS:FindFirstChild("RemoteEvents")
	local re = remotes and remotes:FindFirstChild(name)
	if re and typeof(player) == "Instance" then re:FireClient(player, payload) end
end

local function finish(userId, p)
	if pending[userId] ~= p then return end
	pending[userId] = nil
	send("PropertyPromptClosed", Players:GetPlayerByUserId(userId), { id = p.id })
	p.event:Fire()
end

-- Blokir Resolution Chain sampai pemain memutuskan.
local function ask(player, kind, tile, payload)
	local userId = player.UserId
	if pending[userId] then return end
	promptSeq += 1
	local p = { id = promptSeq, kind = kind, tile = tile, event = Instance.new("BindableEvent") }
	pending[userId] = p
	payload.id, payload.kind, payload.tile = p.id, kind, tile
	payload.name = BoardConfig.Tiles[tile].name
	payload.district = BoardConfig.Tiles[tile].district
	payload.balance = Economy.getBalance(userId)
	send("PropertyPrompt", player, payload)
	p.event.Event:Wait()
	p.event:Destroy()
end

PropertyFlow.ask = ask -- dipakai CrownFlow / RewardFlow (prompt memblokir Resolution Chain)

-- fn(player, pendingPrompt, data) -> ok, reason. allowCancel=false: prompt wajib diselesaikan.
function PropertyFlow.registerKind(kind, fn, opts)
	extraKinds[kind] = { fn = fn, allowCancel = not (opts and opts.allowCancel == false) }
end

function PropertyFlow.getPendingId(userId)
	local p = pending[userId]
	return p and p.id or nil
end

-- ===== Landing handler =====
local function landing(player, tile)
	local userId = player.UserId
	local owner = PropertyService.getOwner(tile)
	local data = PropertyData.Properties[tile]

	if owner == nil then
		-- Unowned: Purchase UI hanya jika mampu membeli minimal L1
		local bal = Economy.getBalance(userId)
		if bal >= data.buy[1] then
			local options = {}
			for lv = 1, 3 do table.insert(options, { level = lv, price = data.buy[lv], enabled = bal >= data.buy[lv] }) end
			ask(player, "buy_unowned", tile, { options = options })
		end

	elseif owner == userId then
		ModifierService.clearSlump(tile) -- siapa pun yang landing mereaktivasi Property Slump
		local level = PropertyService.getLevel(tile)
		if level < 5 and PropertyService.canUpgradeThisTurn(userId) then
			local bal = Economy.getBalance(userId)
			local options = {}
			local targets = (level == 1) and { 2, 3 } or { level + 1 } -- L1 boleh langsung ke L3
			for _, to in ipairs(targets) do
				local cost = PropertyService.upgradeCost(tile, level, to)
				if cost then table.insert(options, { level = to, price = cost, enabled = bal >= cost }) end
			end
			if #options > 0 then
				ask(player, "upgrade", tile, { currentLevel = level, options = options })
			end
		end

	else
		-- Other Player: Rent dulu, baru boleh Buy Property (L1-L4)
		local wasSlump = ModifierService.isSlump(tile)
		local amount, recipients = PropertyService.rentPayout(tile, userId)
		if amount > 0 then
			landingSeq += 1
			local r = Economy.pay(userId, amount, {
				allowNegative = true, recipients = recipients, opId = ("rent:%d"):format(landingSeq),
			})
			if r.result ~= Result.CONTINUE then return r.result end
			if not r.ok then warn("[PropertyFlow] Rent gagal: " .. tostring(r.reason)) end
		end
		if wasSlump then ModifierService.clearSlump(tile) end -- landing ini rent = 0, Property kembali Active
		if not GameState.isRunning() then return Result.GAME_END end
		local level = PropertyService.getLevel(tile)
		if PropertyService.getOwner(tile) ~= userId and level <= 4 then
			local price = PropertyService.value(tile)
			if Economy.getBalance(userId) >= price then
				ask(player, "buy_other", tile, { currentLevel = level, price = price, ownerUserId = PropertyService.getOwner(tile) })
			end
		end
	end

	if not GameState.isRunning() then return Result.GAME_END end
	return Result.CONTINUE
end

-- ===== Intent dari client (untrusted) =====
function PropertyFlow.handleAction(player, data)
	if typeof(data) ~= "table" or typeof(data.id) ~= "number" or typeof(data.action) ~= "string" then return false end
	local userId = player.UserId
	local p = pending[userId]
	if not p or p.id ~= data.id then return false end -- basi / duplikat / bukan prompt aktif
	if not GameState.gate() then return false end
	if not TurnController.isCurrentPlayer(player) then return false end

	if data.action == "cancel" then
		local ek = extraKinds[p.kind]
		if ek and not ek.allowCancel then return false end
		finish(userId, p)
		return true
	end

	local ok, why
	if p.kind == "buy_unowned" and data.action == "buy" and typeof(data.level) == "number" then
		ok, why = PropertyService.purchase(userId, p.tile, data.level, { opId = "buy:" .. p.id })
	elseif p.kind == "upgrade" and data.action == "upgrade" and typeof(data.level) == "number" then
		ok, why = PropertyService.upgrade(userId, p.tile, data.level, { opId = "upgrade:" .. p.id })
	elseif p.kind == "buy_other" and data.action == "buy" then
		ok, why = PropertyService.buyFromOwner(userId, p.tile, { opId = "buyother:" .. p.id })
	elseif extraKinds[p.kind] then
		ok, why = extraKinds[p.kind].fn(player, p, data)
	else
		return false
	end

	if ok then
		finish(userId, p)
		return true
	end
	-- ditolak: zero side effect, prompt tetap terbuka
	send("Notify", player, { text = tostring(why) })
	return false, why
end

-- Registrasi logika (tanpa koneksi RemoteEvent) -- dipisah supaya bisa diuji di Edit mode.
local setupDone = false
function PropertyFlow.setup()
	if setupDone then return end
	setupDone = true
	PropertyService.init()
	Liquidation.registerSource(PropertyService.LiquidationSource)
	Economy.setLiquidationProvider(Liquidation)
	LandingResolver.register("Property", landing)

	Players.PlayerRemoving:Connect(function(player)
		local p = pending[player.UserId]
		if p then finish(player.UserId, p) end
	end)
	GameState.Changed:Connect(function()
		if not GameState.isRunning() then
			for userId, p in pairs(table.clone(pending)) do finish(userId, p) end
		end
	end)
end

local inited = false
function PropertyFlow.init()
	if inited then return end
	inited = true
	PropertyFlow.setup()
	Liquidation.init()
	RS.RemoteEvents:WaitForChild("PropertyAction").OnServerEvent:Connect(function(player, data)
		PropertyFlow.handleAction(player, data)
	end)
end

return PropertyFlow
