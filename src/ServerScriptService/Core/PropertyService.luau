-- PropertyService (server-only): ownership, level, purchase, upgrade, rent, Set, liquidation source.
-- Semua perubahan state lewat modul ini; client hanya mengirim intent (lewat PropertyFlow).
-- Upgrade langsung L1 -> L3 = Buy L3 - Buy L1 (keputusan desain). Jalur bertahap L1->L2->L3 tetap lebih murah.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Constants = require(RS.Modules.Constants)
local BoardConfig = require(RS.Modules.BoardConfig)
local PropertyData = require(RS.Modules.PropertyData)
local GameState = require(SSS.Core.GameState)
local Economy = require(SSS.Core.Economy)
local TurnController = require(SSS.Core.TurnController)

local UNIT = Constants.CURRENCY_UNIT

local PropertyService = {}

local state = {}            -- [tile] = { owner = userId|nil, level = 1..5 }
local lastUpgradeTurn = {}  -- [userId] = nomor turn upgrade normal terakhir
local rentModifierProvider = nil -- function(tile) -> { inactive=bool, multiplier=number, halfRentHolder=userId } | nil
local inited = false
local transferHooks, releaseHooks = {}, {} -- sinkron: modifier harus bersih sebelum ada pembacaan berikutnya

local function newEvent() return Instance.new("BindableEvent") end
local changedE, transferredE, releasedE = newEvent(), newEvent(), newEvent()
PropertyService.Changed = changedE.Event         -- (reason, tile)  -> hook Global Victory Check
PropertyService.Transferred = transferredE.Event -- (tile, oldOwner, newOwner)
PropertyService.Released = releasedE.Event       -- (tile) Property jadi Unowned: Property Modifier dihapus

local function publish(tile)
	local part = BoardConfig.getTilePart(tile)
	if not part then return end
	local st = state[tile]
	local owner = st.owner
	local plr = owner and Players:GetPlayerByUserId(owner)
	local rec = owner and GameState.getRecord(owner)
	part:SetAttribute("OwnerUserId", owner)
	part:SetAttribute("OwnerName", plr and plr.Name or nil)
	part:SetAttribute("OwnerSlot", rec and rec.slot or nil)
	part:SetAttribute("Level", st.level)
end

local function after(reason, tile)
	publish(tile)
	changedE:Fire(reason, tile)
end

function PropertyService.init()
	if inited then return end
	inited = true
	for tile, info in pairs(BoardConfig.Tiles) do
		if info.type == "Property" then
			state[tile] = { owner = nil, level = 1 }
			publish(tile)
		end
	end
end

function PropertyService.setRentModifierProvider(fn) rentModifierProvider = fn end
function PropertyService.addTransferHook(fn) table.insert(transferHooks, fn) end -- fn(tile, oldOwner, newOwner)
function PropertyService.addReleaseHook(fn) table.insert(releaseHooks, fn) end   -- fn(tile)

-- Jumlah Property L5 di seluruh room (menentukan Reward 2x / 3x)
function PropertyService.countL5Total()
	local n = 0
	for _, s in pairs(state) do
		if s.owner ~= nil and s.level == 5 then n += 1 end
	end
	return n
end

-- ===== Query =====
function PropertyService.isProperty(tile) return state[tile] ~= nil end
function PropertyService.getOwner(tile) local s = state[tile]; return s and s.owner end
function PropertyService.getLevel(tile) local s = state[tile]; return s and s.level end

function PropertyService.getTilesOf(userId)
	local list = {}
	for tile, s in pairs(state) do
		if s.owner == userId then table.insert(list, tile) end
	end
	table.sort(list)
	return list
end

function PropertyService.countInDistrict(userId, district)
	local n = 0
	for tile, s in pairs(state) do
		if s.owner == userId and BoardConfig.Tiles[tile].district == district then n += 1 end
	end
	return n
end

function PropertyService.countAtLevel(userId, level)
	local n = 0
	for _, s in pairs(state) do
		if s.owner == userId and s.level == level then n += 1 end
	end
	return n
end

function PropertyService.isSetComplete(tile)
	local info = BoardConfig.Tiles[tile]
	local owner = PropertyService.getOwner(tile)
	if not info or not info.set or not owner then return false end
	for _, t in ipairs(BoardConfig.Sets[info.set]) do
		if PropertyService.getOwner(t) ~= owner then return false end
	end
	return true
end

function PropertyService.countCompleteSets(userId)
	local n = 0
	for setId, tiles in pairs(BoardConfig.Sets) do
		local all = true
		for _, t in ipairs(tiles) do
			if PropertyService.getOwner(t) ~= userId then all = false break end
		end
		if all then n += 1 end
	end
	return n
end

function PropertyService.value(tile)
	local s = state[tile]
	return s and PropertyData.value(tile, s.level) or nil
end

-- ===== Rent: Slump check -> Base -> Set -> Multipliers -> Rounding (sekali) =====
function PropertyService.computeRent(tile)
	local s = state[tile]
	if not s or not s.owner then return 0, {} end
	local mods = rentModifierProvider and rentModifierProvider(tile) or nil
	if mods and mods.inactive then return 0, { inactive = true } end
	local p = PropertyData.Properties[tile]
	local complete = PropertyService.isSetComplete(tile)
	local base = (complete and p.setRent) and p.setRent[s.level] or p.rent[s.level]
	local mult = mods and mods.multiplier or 1
	return Economy.roundToUnit(base * mult), {
		base = base, setComplete = complete, multiplier = mult,
		halfRentHolder = mods and mods.halfRentHolder or nil,
	}
end

-- Tenant selalu membayar Final Rent penuh. Half Rent: bagian holder dibulatkan ke bawah, sisa ke Owner.
-- (Holder == Tenant belum didefinisikan -> tanpa split, Owner menerima penuh.)
function PropertyService.rentPayout(tile, tenantId)
	local amount, detail = PropertyService.computeRent(tile)
	local owner = PropertyService.getOwner(tile)
	if amount <= 0 or not owner then return 0, nil end
	local holder = detail.halfRentHolder
	if holder and holder ~= owner and holder ~= tenantId and GameState.isActive(holder) then
		local share = math.floor(amount / 2 / UNIT) * UNIT
		if share > 0 then
			return amount, { { userId = holder, amount = share }, { userId = owner, amount = amount - share } }
		end
	end
	return amount, { { userId = owner, amount = amount } }
end

-- ===== Mutasi =====
local function precheck(userId)
	local ok, why = GameState.gate()
	if not ok then return false, why end
	if not GameState.isActive(userId) then return false, "NOT_ACTIVE" end
	return true
end

function PropertyService.purchase(userId, tile, level, opts)
	opts = opts or {}
	local ok, why = precheck(userId)
	if not ok then return false, why end
	local s = state[tile]
	if not s then return false, "NOT_PROPERTY" end
	if s.owner ~= nil then return false, "ALREADY_OWNED" end
	if level ~= 1 and level ~= 2 and level ~= 3 then return false, "INVALID_LEVEL" end -- L4/L5 bukan initial purchase
	local price = PropertyData.Properties[tile].buy[level]
	local r = Economy.pay(userId, price, { opId = opts.opId }) -- sukarela: tidak boleh Negative Balance
	if not r.ok then return false, r.reason end
	s.owner, s.level = userId, level -- tanpa yield antara pay dan ownership: atomic
	after("PURCHASE", tile)
	return true, price
end

function PropertyService.upgradeCost(tile, from, to)
	local p = PropertyData.Properties[tile]
	if not p then return nil, "NOT_PROPERTY" end
	if to == from + 1 and p.upgrade[from] then return p.upgrade[from] end
	if from == 1 and to == 3 then return p.buy[3] - p.buy[1] end
	return nil, "INVALID_PATH"
end

function PropertyService.canUpgradeThisTurn(userId)
	return lastUpgradeTurn[userId] ~= TurnController.getTurnNumber()
end

function PropertyService.upgrade(userId, tile, toLevel, opts)
	opts = opts or {}
	local ok, why = precheck(userId)
	if not ok then return false, why end
	local s = state[tile]
	if not s then return false, "NOT_PROPERTY" end
	if s.owner ~= userId then return false, "NOT_OWNER" end
	if typeof(toLevel) ~= "number" or s.level >= 5 then return false, "INVALID_PATH" end
	if not opts.ignoreTurnLimit and not PropertyService.canUpgradeThisTurn(userId) then
		return false, "UPGRADE_LIMIT" -- maksimal 1 upgrade per turn
	end
	local cost, err = PropertyService.upgradeCost(tile, s.level, toLevel)
	if not cost then return false, err end
	local r = Economy.pay(userId, cost, { opId = opts.opId })
	if not r.ok then return false, r.reason end
	s.level = toLevel
	if not opts.ignoreTurnLimit then lastUpgradeTurn[userId] = TurnController.getTurnNumber() end
	after("UPGRADE", tile)
	return true, cost
end

-- Landing di Property pemain lain (L1-L4): setelah Rent, Buyer membayar Current Value ke Owner. Level tidak berubah.
function PropertyService.buyFromOwner(buyerId, tile, opts)
	opts = opts or {}
	local ok, why = precheck(buyerId)
	if not ok then return false, why end
	local s = state[tile]
	if not s then return false, "NOT_PROPERTY" end
	if s.owner == nil or s.owner == buyerId then return false, "INVALID_OWNER" end
	if s.level > 4 then return false, "L5_NOT_PURCHASABLE" end
	local price = PropertyData.value(tile, s.level)
	local oldOwner = s.owner
	local r = Economy.pay(buyerId, price, { recipients = { { userId = oldOwner, amount = price } }, opId = opts.opId })
	if not r.ok then return false, r.reason end
	PropertyService.transfer(tile, buyerId)
	return true, price
end

-- Transfer ownership (Trade, Transaction, Seizure, Grand Exchange, Forced Transaction). Level & modifier ikut Property.
function PropertyService.transfer(tile, newOwnerId)
	local s = state[tile]
	if not s or not GameState.isRunning() then return false end
	if newOwnerId == nil then return PropertyService.release(tile) end
	local old = s.owner
	s.owner = newOwnerId
	for _, h in ipairs(transferHooks) do h(tile, old, newOwnerId) end
	publish(tile)
	transferredE:Fire(tile, old, newOwnerId)
	changedE:Fire("TRANSFER", tile)
	return true
end

-- Property menjadi Unowned: L1 + Clean.
function PropertyService.release(tile)
	local s = state[tile]
	if not s or not GameState.isRunning() then return false end
	s.owner, s.level = nil, 1
	for _, h in ipairs(releaseHooks) do h(tile) end
	releasedE:Fire(tile)
	after("RELEASE", tile)
	return true
end

-- Dipakai News (Property Damage, Construction Setback, Instant Upgrade, Land Grant).
function PropertyService.setLevel(tile, level)
	local s = state[tile]
	if not s or not s.owner or not GameState.isRunning() then return false end
	if level < 1 then return PropertyService.release(tile) end
	s.level = math.min(level, 5)
	after("LEVEL", tile)
	return true
end

function PropertyService.grant(tile, userId, level)
	local s = state[tile]
	if not s or s.owner ~= nil or not GameState.isRunning() or not GameState.isActive(userId) then return false end
	s.owner, s.level = userId, level or 1
	after("GRANT", tile)
	return true
end

-- ===== Sumber aset Liquidation: jual ke Bank ~80% Current Value (dibulatkan 500) -> Unowned + L1 =====
local function liquidationValue(tile)
	return Economy.roundToUnit(PropertyService.value(tile) * Constants.PROPERTY_LIQUIDATION_RATE)
end

PropertyService.LiquidationSource = {
	kind = "Property",
	list = function(userId)
		local out = {}
		for _, tile in ipairs(PropertyService.getTilesOf(userId)) do
			table.insert(out, {
				id = tile, label = BoardConfig.Tiles[tile].name, value = liquidationValue(tile),
				setBreak = PropertyService.isSetComplete(tile), -- UI wajib memberi warning sebelum menjual
			})
		end
		return out
	end,
	sell = function(userId, tile)
		if typeof(tile) ~= "number" then return false end
		local s = state[tile]
		if not s or s.owner ~= userId then return false end
		local proceeds = liquidationValue(tile)
		if not Economy.credit(userId, proceeds) then return false end
		PropertyService.release(tile)
		return true
	end,
}

return PropertyService
