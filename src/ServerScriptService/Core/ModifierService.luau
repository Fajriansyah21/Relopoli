-- ModifierService (server-only): semua modifier + timer Round.
-- Durasi 3 Round (crossing 39->0). Round saat modifier diperoleh TIDAK dihitung. Timer mengikuti pemain yang
-- pertama memperoleh modifier (Time Reference), tidak di-reset saat Property berpindah.
-- Same modifier -> Refresh; Different modifier -> Stack. Property -> Unowned: semua Property Modifier dihapus.
-- UNRESOLVED: nasib modifier jika Time Reference-nya tereliminasi (tidak ada di dokumen). Sementara timer berhenti.
-- Refresh: Time Reference berpindah ke pemain yang me-refresh (asumsi; dokumen hanya menyebut "Refresh Duration").

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Constants = require(RS.Modules.Constants)
local GameState = require(SSS.Core.GameState)
local PropertyService = require(SSS.Core.PropertyService)
local CrownService = require(SSS.Core.CrownService)
local StartService = require(SSS.Core.StartService)

local ModifierService = {}

local propMods = {}   -- [tile] = { PremiumListing = entry, FallingDemand = entry, HalfRent = entry(+holder), Slump = true }
local crownMods = {}  -- [tile] = { Prosperity = entry, Disruption = true }
local rewards = {}    -- [userId] = { tile, multiplier, entry }  (Player Modifier: 1 Reward aktif per pemain)
local inited = false

local expiredE = Instance.new("BindableEvent")
ModifierService.Expired = expiredE.Event -- (scope, tile, kind)

local PROPERTY_TIMED = { "PremiumListing", "FallingDemand", "HalfRent" }

local function newEntry(refUserId)
	return { roundsLeft = Constants.MODIFIER_DURATION_ROUNDS, skipNext = true, ref = refUserId }
end

-- true jika modifier habis. skipNext = Round saat modifier diperoleh tidak dihitung.
local function tickEntry(e)
	if e.skipNext then e.skipNext = false return false end
	e.roundsLeft -= 1
	return e.roundsLeft <= 0
end

local function gate()
	local ok, why = GameState.gate()
	return ok, why
end

-- ===== Property Modifier =====
function ModifierService.applyPropertyModifier(tile, kind, refUserId)
	local ok, why = gate()
	if not ok then return false, why end
	local owner = PropertyService.getOwner(tile)
	if not owner then return false, "UNOWNED" end
	if not GameState.isActive(refUserId) then return false, "NOT_ACTIVE" end
	local t = propMods[tile]
	if not t then t = {}; propMods[tile] = t end

	if kind == "HalfRent" then
		if t.HalfRent then return false, "HALF_RENT_EXISTS" end   -- 1 Half Rent Holder per Property, tidak stack
		if refUserId == owner then return false, "HOLDER_IS_OWNER" end
		t.HalfRent = newEntry(refUserId)
		t.HalfRent.holder = refUserId
		return true, "APPLIED"
	elseif kind == "PremiumListing" or kind == "FallingDemand" then
		local existed = t[kind] ~= nil
		t[kind] = newEntry(refUserId)       -- sama -> Refresh (bukan stack)
		return true, existed and "REFRESHED" or "APPLIED"
	end
	return false, "INVALID_KIND"
end

function ModifierService.canApplyHalfRent(tile)
	local owner = PropertyService.getOwner(tile)
	if not owner then return false end
	local t = propMods[tile]
	return not (t and t.HalfRent)
end

function ModifierService.setSlump(tile)
	local ok, why = gate()
	if not ok then return false, why end
	if not PropertyService.getOwner(tile) then return false, "UNOWNED" end
	local t = propMods[tile]
	if not t then t = {}; propMods[tile] = t end
	t.Slump = true
	return true
end
function ModifierService.isSlump(tile)
	local t = propMods[tile]
	return t ~= nil and t.Slump == true
end
function ModifierService.clearSlump(tile)
	local t = propMods[tile]
	if t then t.Slump = nil end
end

-- ===== Reward (Player Modifier) =====
function ModifierService.setReward(userId, tile, multiplier)
	local ok, why = gate()
	if not ok then return false, why end
	if not GameState.isActive(userId) then return false, "NOT_ACTIVE" end
	if PropertyService.getOwner(tile) ~= userId then return false, "NOT_OWNER" end
	if multiplier ~= Constants.REWARD_MULTIPLIER and multiplier ~= Constants.REWARD_MULTIPLIER_WITH_L5 then
		return false, "INVALID_MULTIPLIER"
	end
	-- Reward baru memindahkan multiplier dari target lama; timer reset
	rewards[userId] = { tile = tile, multiplier = multiplier, entry = newEntry(userId) }
	return true
end
function ModifierService.getReward(userId) return rewards[userId] end

-- ===== Crown Modifier =====
function ModifierService.applyProsperity(tile, refUserId)
	local ok, why = gate()
	if not ok then return false, why end
	if not CrownService.getOwner(tile) then return false, "UNOWNED" end
	local t = crownMods[tile]
	if not t then t = {}; crownMods[tile] = t end
	local existed = t.Prosperity ~= nil
	t.Prosperity = newEntry(refUserId)  -- sama -> Refresh, tetap +2.000
	return true, existed and "REFRESHED" or "APPLIED"
end

function ModifierService.setDisruption(tile)
	local ok, why = gate()
	if not ok then return false, why end
	if not CrownService.getOwner(tile) then return false, "UNOWNED" end
	local t = crownMods[tile]
	if not t then t = {}; crownMods[tile] = t end
	t.Disruption = true                  -- sudah Disrupted: tetap, tanpa efek tambahan; tidak pause timer Prosperity
	return true
end
function ModifierService.isDisrupted(tile) local t = crownMods[tile]; return t ~= nil and t.Disruption == true end
function ModifierService.prosperityActive(tile) local t = crownMods[tile]; return t ~= nil and t.Prosperity ~= nil end
function ModifierService.clearDisruption(tile) local t = crownMods[tile]; if t then t.Disruption = nil end end

-- ===== Query UI (Assets Panel: Status / Modifier) =====
function ModifierService.describe(tile)
	local out = {}
	local t = propMods[tile]
	if t then
		for _, kind in ipairs(PROPERTY_TIMED) do
			if t[kind] then table.insert(out, { kind = kind, roundsLeft = t[kind].roundsLeft, holder = t[kind].holder }) end
		end
		if t.Slump then table.insert(out, { kind = "Slump" }) end
	end
	local owner = PropertyService.getOwner(tile)
	local rw = owner and rewards[owner]
	if rw and rw.tile == tile then table.insert(out, { kind = "Reward", multiplier = rw.multiplier, roundsLeft = rw.entry.roundsLeft }) end
	local c = crownMods[tile]
	if c then
		if c.Prosperity then table.insert(out, { kind = "Prosperity", roundsLeft = c.Prosperity.roundsLeft }) end
		if c.Disruption then table.insert(out, { kind = "Disruption" }) end
	end
	return out
end

-- ===== Timer: dipanggil tiap crossing 39 -> 0 oleh pemain userId =====
function ModifierService.onRoundComplete(userId)
	for tile, t in pairs(propMods) do
		for _, kind in ipairs(PROPERTY_TIMED) do
			local e = t[kind]
			if e and e.ref == userId and tickEntry(e) then
				t[kind] = nil
				expiredE:Fire("Property", tile, kind)
			end
		end
	end
	for tile, t in pairs(crownMods) do
		local e = t.Prosperity
		if e and e.ref == userId and tickEntry(e) then
			t.Prosperity = nil
			expiredE:Fire("Crown", tile, "Prosperity")
		end
	end
	local rw = rewards[userId]
	if rw and tickEntry(rw.entry) then
		rewards[userId] = nil
		expiredE:Fire("Reward", rw.tile, "Reward")
	end
end

-- ===== Rent provider: Slump -> multiplier (Reward x Premium x Falling) -> Half Rent holder =====
local function rentProvider(tile)
	local owner = PropertyService.getOwner(tile)
	if not owner then return nil end
	local mult, inactive, holder = 1, false, nil
	local t = propMods[tile]
	if t then
		if t.Slump then inactive = true end
		if t.PremiumListing then mult *= Constants.PREMIUM_LISTING_MULTIPLIER end
		if t.FallingDemand then mult *= Constants.FALLING_DEMAND_MULTIPLIER end
		if t.HalfRent then holder = t.HalfRent.holder end
	end
	local rw = rewards[owner]
	if rw and rw.tile == tile then mult *= rw.multiplier end   -- Reward hanya jika target masih milik pemainnya
	return { inactive = inactive, multiplier = mult, halfRentHolder = holder }
end

function ModifierService.init()
	if inited then return end
	inited = true
	PropertyService.setRentModifierProvider(rentProvider)

	PropertyService.addReleaseHook(function(tile)
		propMods[tile] = nil                                  -- Unowned: semua Property Modifier dihapus (Clean)
		for userId, rw in pairs(rewards) do
			if rw.tile == tile then rewards[userId] = nil end
		end
	end)
	PropertyService.addTransferHook(function(tile, _old, newOwner)
		local t = propMods[tile]
		if t then
			t.Slump = nil                                       -- Slump hilang saat ownership berpindah
			if t.HalfRent and t.HalfRent.holder == newOwner then t.HalfRent = nil end -- Holder jadi Owner
		end
		for userId, rw in pairs(rewards) do
			if rw.tile == tile and userId ~= newOwner then rewards[userId] = nil end  -- Reward hilang jika target pindah
		end
	end)

	CrownService.setStatusProvider({
		prosperity = ModifierService.prosperityActive,
		disrupted = ModifierService.isDisrupted,
		clearDisruption = ModifierService.clearDisruption,
	})
	CrownService.addTransferHook(function(tile) crownMods[tile] = nil end) -- Crown berpindah -> Clean
	CrownService.addReleaseHook(function(tile) crownMods[tile] = nil end)  -- Destroyed/Liquidated -> Clean

	StartService.RoundCompleted:Connect(function(userId)
		ModifierService.onRoundComplete(userId)
	end)
end

-- Event Changed untuk UI (Assets Panel): setiap mutasi publik menembakkan event (UI hanya merefresh state dari server).
local changedE = Instance.new("BindableEvent")
ModifierService.Changed = changedE.Event
for _, name in ipairs({ "applyPropertyModifier", "setSlump", "clearSlump", "setReward",
	"applyProsperity", "setDisruption", "clearDisruption", "onRoundComplete" }) do
	local orig = ModifierService[name]
	ModifierService[name] = function(...)
		local a, b = orig(...)
		changedE:Fire(name)
		return a, b
	end
end

return ModifierService
