-- VictoryService (server-only): Global Victory Check dari state authoritative terbaru.
-- 4 kondisi: Last Player Standing, 4 Crown, 4 Official Set, L5 Threshold dinamis (4->18, 3->21, 2->23).
-- Dipicu setelah State Change (Property, Crown, Final Bankruptcy). Handler event di-defer supaya Atomic Operation
-- yang sedang berjalan selesai dulu (Victory Check tidak memotong operasi).

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Constants = require(RS.Modules.Constants)
local GameState = require(SSS.Core.GameState)
local Economy = require(SSS.Core.Economy)
local PropertyService = require(SSS.Core.PropertyService)
local CrownService = require(SSS.Core.CrownService)

local VictoryService = {}
local inited = false

local endedE = Instance.new("BindableEvent")
VictoryService.Ended = endedE.Event -- (winnerUserId, reason)

-- return winnerUserId, reason (tanpa mengubah state)
function VictoryService.evaluate()
	local active = GameState.getActiveUserIds()
	if #active == 0 then return nil end

	-- Last Player Standing hanya berlaku bila game dimulai dengan >= 2 pemain
	if #active == 1 and #GameState.getOrder() >= 2 then
		return active[1], "LAST_PLAYER_STANDING"
	end

	local l5Target = Constants.L5_VICTORY_TARGET[#active]
	for _, userId in ipairs(active) do
		if CrownService.countOwned(userId) >= Constants.CROWN_COUNT then return userId, "CROWN_VICTORY" end
		if PropertyService.countCompleteSets(userId) >= Constants.SET_COUNT then return userId, "SET_VICTORY" end
		if l5Target and PropertyService.countAtLevel(userId, 5) >= l5Target then return userId, "L5_VICTORY" end
	end
	return nil
end

function VictoryService.check()
	if not GameState.isRunning() then return nil end
	local winner, reason = VictoryService.evaluate()
	if not winner then return nil end
	if GameState.endGame(winner) then
		endedE:Fire(winner, reason)
		return winner, reason
	end
	return nil
end

function VictoryService.init()
	if inited then return end
	inited = true
	local function deferred() task.defer(VictoryService.check) end
	PropertyService.Changed:Connect(deferred)
	CrownService.Changed:Connect(deferred)
	Economy.Eliminated:Connect(deferred)
end

return VictoryService
