-- GameState (server-only): satu-satunya sumber kebenaran state gameplay.
-- Client hanya mengirim intent; semua perubahan state lewat modul ini / sistem server.

local RS = game:GetService("ReplicatedStorage")
local Constants = require(RS.Modules.Constants)

local GameState = {}

local state = Constants.GameState.RUNNING
local winnerUserId = nil

local records = {}      -- [userId] = { player, slot, state }
local order = {}        -- array userId, urutan giliran (slot)
local processedOps = {} -- [opId] = true (dedupe request/operasi satu kali)

local changed = Instance.new("BindableEvent")
GameState.Changed = changed.Event

local function fire(reason)
	changed:Fire(reason)
end

-- ===== Game State Gate =====
function GameState.isRunning()
	return state == Constants.GameState.RUNNING
end

function GameState.get()
	return state
end

function GameState.getWinner()
	return winnerUserId
end

-- Setiap action gameplay wajib memanggil ini lebih dulu.
function GameState.gate()
	if state ~= Constants.GameState.RUNNING then
		return false, "GAME_ENDED"
	end
	return true
end

-- ===== Player registry =====
function GameState.registerPlayer(player)
	if records[player.UserId] then return records[player.UserId] end
	if #order >= Constants.MAX_PLAYERS then return nil, "ROOM_FULL" end
	local slot = #order + 1
	local rec = { player = player, slot = slot, state = Constants.PlayerState.ACTIVE }
	records[player.UserId] = rec
	table.insert(order, player.UserId)
	fire("PLAYER_REGISTERED")
	return rec
end

function GameState.getRecord(playerOrUserId)
	local id = typeof(playerOrUserId) == "Instance" and playerOrUserId.UserId or playerOrUserId
	return records[id]
end

function GameState.getSlotColor(userId)
	local rec = records[userId]
	return rec and Constants.PLAYER_COLORS[rec.slot] or nil
end

function GameState.isActive(playerOrUserId)
	local rec = GameState.getRecord(playerOrUserId)
	return rec ~= nil and rec.state == Constants.PlayerState.ACTIVE
end

function GameState.setPlayerState(userId, newState)
	local rec = records[userId]
	if not rec then return false end
	if state == Constants.GameState.ENDED and newState ~= Constants.PlayerState.WINNER then
		return false
	end
	rec.state = newState
	fire("PLAYER_STATE")
	return true
end

-- Array userId aktif sesuai urutan slot
function GameState.getActiveUserIds()
	local list = {}
	for _, id in ipairs(order) do
		local rec = records[id]
		if rec and rec.state == Constants.PlayerState.ACTIVE then
			table.insert(list, id)
		end
	end
	return list
end

function GameState.getActiveCount()
	return #GameState.getActiveUserIds()
end

function GameState.getOrder()
	return table.clone(order)
end

-- ===== Game End (hard stop) =====
function GameState.endGame(winnerId)
	if state == Constants.GameState.ENDED then return false end
	state = Constants.GameState.ENDED
	winnerUserId = winnerId
	for id, rec in pairs(records) do
		if id == winnerId then
			rec.state = Constants.PlayerState.WINNER
		elseif rec.state == Constants.PlayerState.ACTIVE then
			-- kalah karena Game End: bukan Bankrupt
			rec.state = Constants.PlayerState.ELIMINATED
		end
	end
	fire("GAME_ENDED")
	return true
end

-- ===== Resolution Result priority =====
-- GAME_END > PLAYER_ELIMINATED > TURN_END > EXTRA_ROLL > CONTINUE
function GameState.combineResults(a, b)
	local pa = Constants.ResultPriority[a] or 0
	local pb = Constants.ResultPriority[b] or 0
	return pa >= pb and a or b
end

-- ===== Dedupe operasi satu kali =====
-- Mengembalikan true hanya pada klaim pertama untuk opId tsb.
function GameState.claimOperation(opId)
	if typeof(opId) ~= "string" or #opId == 0 or #opId > 100 then return false end
	if processedOps[opId] then return false end
	processedOps[opId] = true
	return true
end

return GameState
