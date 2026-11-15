-- AssetsService (server-only): snapshot aset pemain untuk Assets Panel (Information Hub).
-- Client TIDAK mengirim userId: server hanya mengembalikan aset milik pemain yang memanggil.
-- Snapshot = representasi state authoritative; Assets tidak membuat Game Rule baru.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local BoardConfig = require(RS.Modules.BoardConfig)
local GameState = require(SSS.Core.GameState)
local Economy = require(SSS.Core.Economy)
local PropertyService = require(SSS.Core.PropertyService)
local CrownService = require(SSS.Core.CrownService)
local ModifierService = require(SSS.Core.ModifierService)

local AssetsService = {}

local function modifiersOf(tile)
	local out = {}
	for _, m in ipairs(ModifierService.describe(tile)) do
		local holderName
		if m.holder then
			local p = Players:GetPlayerByUserId(m.holder)
			holderName = p and p.Name or nil
		end
		table.insert(out, { kind = m.kind, roundsLeft = m.roundsLeft, multiplier = m.multiplier, holderName = holderName })
	end
	return out
end

function AssetsService.snapshot(userId)
	local rec = GameState.getRecord(userId)
	local plr = Players:GetPlayerByUserId(userId)
	local snap = {
		userId = userId,
		name = plr and plr.Name or (rec and rec.name) or "Player",
		slot = rec and rec.slot or 1,
		balance = Economy.getBalance(userId),
		properties = {},
		crowns = {},
	}

	for _, tile in ipairs(PropertyService.getTilesOf(userId)) do
		local info = BoardConfig.Tiles[tile]
		local rent = PropertyService.computeRent(tile)
		local setProgress
		if info.set then
			local members, owned = {}, 0
			for _, t in ipairs(BoardConfig.Sets[info.set]) do
				local mine = PropertyService.getOwner(t) == userId
				if mine then owned += 1 end
				table.insert(members, { tile = t, name = BoardConfig.Tiles[t].name, owned = mine })
			end
			setProgress = { id = info.set, owned = owned, total = #members, members = members, complete = owned == #members }
		end
		table.insert(snap.properties, {
			tile = tile, name = info.name, district = info.district, level = PropertyService.getLevel(tile),
			value = PropertyService.value(tile), rent = rent, set = setProgress, modifiers = modifiersOf(tile),
		})
	end

	for _, tile in ipairs(CrownService.getCrownsOf(userId)) do
		local info = BoardConfig.Tiles[tile]
		table.insert(snap.crowns, {
			tile = tile, name = info.name, district = info.district,
			value = CrownService.value(tile), modifiers = modifiersOf(tile),
		})
	end
	return snap
end

local inited = false
function AssetsService.init()
	if inited then return end
	inited = true
	local remotes = RS:WaitForChild("RemoteEvents")
	local getAssets = remotes:WaitForChild("GetAssets")
	local changed = remotes:WaitForChild("AssetsChanged")

	local lastCall, lastSnap = {}, {}
	getAssets.OnServerInvoke = function(player)
		local now = os.clock()
		local userId = player.UserId
		if lastCall[userId] and now - lastCall[userId] < 0.2 and lastSnap[userId] then
			return lastSnap[userId] -- anti spam
		end
		if not GameState.getRecord(userId) then return nil end
		lastCall[userId] = now
		lastSnap[userId] = AssetsService.snapshot(userId)
		return lastSnap[userId]
	end
	Players.PlayerRemoving:Connect(function(p) lastCall[p.UserId] = nil; lastSnap[p.UserId] = nil end)

	-- Push ringan: client yang sedang membuka Assets meminta ulang snapshot dari server.
	local queued = false
	local function push()
		if queued then return end
		queued = true
		task.delay(0.15, function()
			queued = false
			changed:FireAllClients({})
		end)
	end
	PropertyService.Changed:Connect(push)
	CrownService.Changed:Connect(push)
	ModifierService.Changed:Connect(push)
	ModifierService.Expired:Connect(push)
end

return AssetsService
