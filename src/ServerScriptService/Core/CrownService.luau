-- CrownService (server-only): ownership, purchase, Crown Reward, transfer/release, liquidation source.
-- Crown tidak punya Rent. Owner lain di Crown = tidak terjadi apa-apa.
-- Status Crown (Prosperity / Disruption) disimpan ModifierService; CrownService membacanya lewat statusProvider.
-- Crown berpindah ownership / hancur / dilikuidasi => Unowned/Owner baru + Clean (Progress 18).
-- ASUMSI (belum eksplisit di dokumen): batas 140.000 berlaku pada Reward dasar; Prosperity +2.000 ditambahkan sesudahnya.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Constants = require(RS.Modules.Constants)
local BoardConfig = require(RS.Modules.BoardConfig)
local GameState = require(SSS.Core.GameState)
local Economy = require(SSS.Core.Economy)
local PropertyService = require(SSS.Core.PropertyService)

local CrownService = {}

local crowns = {}          -- [tile] = { owner = userId|nil }
local statusProvider = nil -- { prosperity(tile)->bool, disrupted(tile)->bool, clearDisruption(tile) }
local transferHooks, releaseHooks = {}, {}
local inited = false

local changedE = Instance.new("BindableEvent")
CrownService.Changed = changedE.Event -- (reason, tile) -> Global Victory Check

local function publish(tile)
	local part = BoardConfig.getTilePart(tile)
	if not part then return end
	local owner = crowns[tile].owner
	local plr = owner and Players:GetPlayerByUserId(owner)
	local rec = owner and GameState.getRecord(owner)
	part:SetAttribute("OwnerUserId", owner)
	part:SetAttribute("OwnerName", plr and plr.Name or nil)
	part:SetAttribute("OwnerSlot", rec and rec.slot or nil)
end

local function after(reason, tile)
	publish(tile)
	changedE:Fire(reason, tile)
end

function CrownService.init()
	if inited then return end
	inited = true
	for tile, info in pairs(BoardConfig.Tiles) do
		if info.type == "Crown" then
			crowns[tile] = { owner = nil }
			publish(tile)
		end
	end
end

function CrownService.setStatusProvider(p) statusProvider = p end
function CrownService.addTransferHook(fn) table.insert(transferHooks, fn) end -- fn(tile, old, new)
function CrownService.addReleaseHook(fn) table.insert(releaseHooks, fn) end   -- fn(tile)

-- ===== Query =====
function CrownService.isCrown(tile) return crowns[tile] ~= nil end
function CrownService.getOwner(tile) local c = crowns[tile]; return c and c.owner end

function CrownService.value(tile)
	local info = BoardConfig.Tiles[tile]
	if not info or info.type ~= "Crown" then return nil end
	return Constants.CROWN_VALUE["D" .. info.district]
end

function CrownService.getCrownsOf(userId)
	local list = {}
	for tile, c in pairs(crowns) do
		if c.owner == userId then table.insert(list, tile) end
	end
	table.sort(list)
	return list
end

function CrownService.countOwned(userId)
	return #CrownService.getCrownsOf(userId)
end

-- ===== Purchase (landing di Crown Unowned) =====
function CrownService.purchase(userId, tile, opts)
	opts = opts or {}
	local ok, why = GameState.gate()
	if not ok then return false, why end
	if not GameState.isActive(userId) then return false, "NOT_ACTIVE" end
	local c = crowns[tile]
	if not c then return false, "NOT_CROWN" end
	if c.owner ~= nil then return false, "ALREADY_OWNED" end
	local price = CrownService.value(tile)
	local r = Economy.pay(userId, price, { opId = opts.opId }) -- sukarela: tidak boleh Negative Balance
	if not r.ok then return false, r.reason end
	c.owner = userId -- tanpa yield antara pay dan ownership: atomic; Crown dibeli = Owned + Clean
	after("PURCHASE", tile)
	return true, price
end

-- ===== Crown Reward: dihitung real-time saat Owner landing =====
function CrownService.computeReward(userId, tile)
	local detail = { base = 0, prosperity = false, disrupted = false }
	local c = crowns[tile]
	if not c or c.owner ~= userId then return 0, detail end
	local district = BoardConfig.Tiles[tile].district
	local count = PropertyService.countInDistrict(userId, district)
	local base = math.min(count * Constants.CROWN_REWARD_PER_PROPERTY, Constants.CROWN_REWARD_MAX)
	detail.base = base
	if statusProvider and statusProvider.disrupted(tile) then
		detail.disrupted = true
		return 0, detail
	end
	if statusProvider and statusProvider.prosperity(tile) then
		detail.prosperity = true
		return base + Constants.CROWN_PROSPERITY_BONUS, detail
	end
	return base, detail
end

-- Hitung -> bayar -> Disruption (jika ada) selesai. return ok, amount, detail
function CrownService.claimReward(userId, tile)
	local ok, why = GameState.gate()
	if not ok then return false, why end
	if not GameState.isActive(userId) then return false, "NOT_ACTIVE" end
	local c = crowns[tile]
	if not c or c.owner ~= userId then return false, "NOT_OWNER" end
	local amount, detail = CrownService.computeReward(userId, tile)
	if amount > 0 then
		local paid = Economy.credit(userId, amount, "CROWN_REWARD")
		if not paid then return false, "CREDIT_FAILED" end
	end
	if detail.disrupted and statusProvider then statusProvider.clearDisruption(tile) end
	return true, amount, detail
end

-- ===== Transfer / Release =====
function CrownService.transfer(tile, newOwnerId)
	local c = crowns[tile]
	if not c or not GameState.isRunning() then return false end
	if newOwnerId == nil then return CrownService.release(tile) end
	local old = c.owner
	c.owner = newOwnerId
	for _, h in ipairs(transferHooks) do h(tile, old, newOwnerId) end -- status Crown -> Clean
	after("TRANSFER", tile)
	return true
end

function CrownService.release(tile) -- Crown Destroyed / Liquidated -> Unowned + Clean
	local c = crowns[tile]
	if not c or not GameState.isRunning() then return false end
	c.owner = nil
	for _, h in ipairs(releaseHooks) do h(tile) end
	after("RELEASE", tile)
	return true
end

-- ===== Sumber aset Liquidation: 100% Crown Value =====
CrownService.LiquidationSource = {
	kind = "Crown",
	list = function(userId)
		local out = {}
		for _, tile in ipairs(CrownService.getCrownsOf(userId)) do
			table.insert(out, { id = tile, label = BoardConfig.Tiles[tile].name, value = CrownService.value(tile) })
		end
		return out
	end,
	sell = function(userId, tile)
		if typeof(tile) ~= "number" then return false end
		local c = crowns[tile]
		if not c or c.owner ~= userId then return false end
		if not Economy.credit(userId, CrownService.value(tile)) then return false end
		CrownService.release(tile)
		return true
	end,
}

return CrownService
