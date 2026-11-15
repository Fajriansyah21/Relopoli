-- Main (server bootstrap): menghubungkan Player, GameState, TurnController, dan Remote.
-- Semua Remote dianggap input tidak tepercaya.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Constants = require(RS.Modules.Constants)
local GameState = require(SSS.Core.GameState)
local TurnController = require(SSS.Core.TurnController)

local Economy = require(SSS.Core.Economy)
local MovementEngine = require(SSS.Core.MovementEngine)
local RollFlow = require(SSS.Core.RollFlow)

local Remotes = RS:WaitForChild("RemoteEvents")
local RequestRoll = Remotes:WaitForChild("RequestRoll")
local RequestSync = Remotes:WaitForChild("RequestSync")

local started = false

require(SSS.Core.BoardSetup).apply()
MovementEngine.init()
RollFlow.init()
require(SSS.Core.PropertyFlow).init()
require(SSS.Core.ModifierService).init()
require(SSS.Core.CrownFlow).init()
require(SSS.Core.RewardFlow).init()
require(SSS.Core.VictoryService).init()
require(SSS.Core.AssetsService).init()

local function onPlayerAdded(player)
	local rec, err = GameState.registerPlayer(player)
	if not rec then
		warn(("[Relopoli] %s tidak bisa masuk giliran: %s"):format(player.Name, tostring(err)))
		return
	end
	Economy.ensure(player.UserId)
	print(("[Relopoli] %s terdaftar sebagai slot %d (%s)"):format(player.Name, rec.slot, Constants.PLAYER_COLORS[rec.slot].name))
	if not started then
		started = true
		task.delay(3, function()
			if GameState.isRunning() then TurnController.start() end
		end)
	end
end

for _, p in ipairs(Players:GetPlayers()) do task.spawn(onPlayerAdded, p) end
Players.PlayerAdded:Connect(onPlayerAdded)

-- Player keluar saat gilirannya: Turn diakhiri lewat Turn Controller.
-- (Aturan Last Player Standing untuk disconnect BELUM didefinisikan di dokumen -> tidak diimplementasikan.)
Players.PlayerRemoving:Connect(function(player)
	if TurnController.isCurrentPlayer(player) and GameState.isRunning() then
		task.defer(function() TurnController.endTurn() end)
	end
end)

-- ===== Intent: Roll =====
RequestRoll.OnServerEvent:Connect(function(player)
	local ok, why = TurnController.requestRoll(player)
	if not ok then
		-- Invalid action = zero side effect
		warn(("[Relopoli] RequestRoll ditolak (%s): %s"):format(player.Name, tostring(why)))
		TurnController.sendStateTo(player) -- UI client disinkronkan ulang dengan state server
	end
end)

-- ===== Intent: minta state giliran terbaru (client baru masuk / UI di-reset) =====
local lastSync = {}
RequestSync.OnServerEvent:Connect(function(player)
	local now = os.clock()
	if lastSync[player.UserId] and now - lastSync[player.UserId] < 0.5 then return end -- anti spam
	lastSync[player.UserId] = now
	TurnController.sendStateTo(player)
end)
Players.PlayerRemoving:Connect(function(player) lastSync[player.UserId] = nil end)

print("[Relopoli] Core aktif")
