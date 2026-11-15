-- ArrowIndicator (shared: server untuk Movement, client untuk View on Board): indikator lokasi/destination di atas tile.
-- Shared system: dipakai Movement (destination) dan nanti View on Board.
-- CATATAN: sementara BillboardGui; model 3D arrow final = polish visual (tidak mengubah gameplay).

local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local BoardConfig = require(RS.Modules.BoardConfig)

local ArrowIndicator = {}

function ArrowIndicator.show(tileIndex, color)
	local tile = BoardConfig.getTilePart(tileIndex)
	if not tile then return nil end

	local gui = Instance.new("BillboardGui")
	gui.Name = "DestArrow"
	gui.Size = UDim2.fromOffset(60, 60)
	gui.StudsOffset = Vector3.new(0, 9, 0)
	gui.AlwaysOnTop = false
	gui.MaxDistance = 250

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = "\u{25BC}"
	label.TextColor3 = color or Color3.new(1, 1, 1)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = gui

	gui.Parent = tile

	-- naik-turun halus, satu tween berulang
	TweenService:Create(gui, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		StudsOffset = Vector3.new(0, 6, 0),
	}):Play()

	return gui
end

function ArrowIndicator.clear(handle)
	if handle then handle:Destroy() end
end

return ArrowIndicator
