-- Liquidation (server-only): Asset Liquidation dipilih sendiri oleh pemain.
-- Dipasang ke Economy sebagai provider { hasAssets, sellOne }. Aset didaftarkan sistem masing-masing (Property, Crown).
-- Tidak ada timeout liquidation di dokumen -> menunggu pilihan pemain; batal hanya jika pemain keluar / Game End.
-- (Disconnect saat liquidation = dianggap tidak menjual -> Economy memproses Final Bankruptcy. Perlu konfirmasi desain.)

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local GameState = require(SSS.Core.GameState)

local Liquidation = {}

local sources = {}  -- { kind, list(userId)->{ {id,label,value,setBreak} }, sell(userId,id)->bool }
local waiting = {}  -- [userId] = BindableEvent

local function send(name, player, payload)
	local remotes = RS:FindFirstChild("RemoteEvents")
	local re = remotes and remotes:FindFirstChild(name)
	if re and typeof(player) == "Instance" then re:FireClient(player, payload) end
end

function Liquidation.registerSource(src)
	table.insert(sources, src)
end

function Liquidation.listAssets(userId)
	local out = {}
	for _, s in ipairs(sources) do
		for _, a in ipairs(s.list(userId)) do
			table.insert(out, { kind = s.kind, id = a.id, label = a.label, value = a.value, setBreak = a.setBreak })
		end
	end
	return out
end

function Liquidation.hasAssets(userId)
	for _, s in ipairs(sources) do
		if #s.list(userId) > 0 then return true end
	end
	return false
end

-- Provider untuk Economy: menunggu pemain memilih 1 aset. true = terjual, false = batal.
function Liquidation.sellOne(userId)
	if waiting[userId] then return false end
	local ev = Instance.new("BindableEvent")
	waiting[userId] = ev
	send("LiquidationPrompt", Players:GetPlayerByUserId(userId), { assets = Liquidation.listAssets(userId) })
	local sold = ev.Event:Wait()
	send("LiquidationClosed", Players:GetPlayerByUserId(userId), {})
	if waiting[userId] == ev then waiting[userId] = nil end
	ev:Destroy()
	return sold == true
end

-- Intent dari client: pilih aset yang dijual. Pilihan tidak valid = zero side effect (tetap menunggu).
function Liquidation.choose(player, kind, id)
	local userId = player.UserId
	local ev = waiting[userId]
	if not ev then return false, "NOT_LIQUIDATING" end
	local ok, why = GameState.gate()
	if not ok then return false, why end
	for _, s in ipairs(sources) do
		if s.kind == kind then
			if s.sell(userId, id) then
				waiting[userId] = nil -- tutup dulu: request ganda tidak menjual aset kedua
				ev:Fire(true)
				return true
			end
			return false, "INVALID_ASSET"
		end
	end
	return false, "INVALID_KIND"
end

function Liquidation.cancel(userId)
	local ev = waiting[userId]
	if ev then
		waiting[userId] = nil
		ev:Fire(false)
	end
end

local inited = false
function Liquidation.init()
	if inited then return end
	inited = true
	local action = RS.RemoteEvents:WaitForChild("LiquidationAction")
	action.OnServerEvent:Connect(function(player, kind, id)
		if typeof(kind) ~= "string" or typeof(id) ~= "number" then return end
		Liquidation.choose(player, kind, id)
	end)
	Players.PlayerRemoving:Connect(function(p) Liquidation.cancel(p.UserId) end)
	GameState.Changed:Connect(function()
		if not GameState.isRunning() then
			for userId in pairs(table.clone(waiting)) do Liquidation.cancel(userId) end
		end
	end)
end

return Liquidation
