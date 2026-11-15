-- RollButton (client): hanya menampilkan tombol saat giliran pemain ini boleh Roll, dan mengirim INTENT (RequestRoll).
-- Server tetap memvalidasi semuanya; tombol disembunyikan/ditampilkan hanya untuk UX.

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Constants = require(RS:WaitForChild("Modules"):WaitForChild("Constants"))
local Remotes = RS:WaitForChild("RemoteEvents")
local RequestRoll = Remotes:WaitForChild("RequestRoll")
local RequestSync = Remotes:WaitForChild("RequestSync")
local TurnChanged = Remotes:WaitForChild("TurnChanged")
local DiceResult = Remotes:WaitForChild("DiceResult")

local Phase = Constants.Phase
local button = script.Parent

local function setShown(on)
	button.Visible = on
	button.Active = on
end

setShown(false)

-- State dari server: { userId, phase, turn, doubleCounter, gameState }
TurnChanged.OnClientEvent:Connect(function(state)
	local mine = state.userId == LocalPlayer.UserId
	local rollPhase = state.phase == Phase.NEWS_PHASE or state.phase == Phase.EXTRA_ROLL_CHECK
	setShown(mine and rollPhase and state.gameState == Constants.GameState.RUNNING)
end)

button.MouseButton1Click:Connect(function()
	if not button.Active then return end
	setShown(false) -- UX saja; jika server menolak, server mengirim state ulang
	RequestRoll:FireServer()
end)

DiceResult.OnClientEvent:Connect(function(d1, d2, total)
	print(("Dadu: %d + %d = %d"):format(d1, d2, total))
end)

-- Ambil state terbaru (client yang baru masuk tidak menerima broadcast sebelumnya)
RequestSync:FireServer()
