-- MovementEngine (server-only): SATU engine untuk semua movement
-- (dice, double, forced, news, transport, jail exit). Mengikuti jalur resmi board tile-per-tile.
-- Server = source of truth posisi (tile index). Client hanya menampilkan.
-- Reward Start BUKAN dibayar di sini: engine hanya melaporkan crossing/landing Start.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

local Constants = require(RS.Modules.Constants)
local BoardConfig = require(RS.Modules.BoardConfig)
local GameState = require(SSS.Core.GameState)
local ArrowIndicator = require(SSS.Core.ArrowIndicator)

local Remotes = RS:WaitForChild("RemoteEvents")
local StartWalkAnim = Remotes:WaitForChild("StartWalkAnim")
local StopWalkAnim = Remotes:WaitForChild("StopWalkAnim")

local MovementEngine = {}

local TILE_COUNT = Constants.TILE_COUNT
local START_TILE = Constants.START_TILE

-- Tuning visual (bukan aturan gameplay)
local BASE_SPEED = 22        -- studs/detik
local LONG_TRIP_BOOST = 0.5  -- perjalanan jauh dipercepat sedikit (maks +50%)
local TURN_SMOOTHING = 14    -- makin besar = rotasi makin cepat
local PRE_DELAY = 1.2        -- arrow tampil dulu sebelum karakter jalan

local GROUP_MOVING = "MovingPlayers"
local GROUP_IDLE = "IdlePlayers"

local tileOf = {}  -- [userId] = tile index (authoritative)
local moving = {}  -- [userId] = true selama movement berjalan (cegah double execution)

-- ===== Collision =====
local function setupGroups()
	for _, n in ipairs({ GROUP_MOVING, GROUP_IDLE }) do
		pcall(function() PhysicsService:RegisterCollisionGroup(n) end)
	end
	PhysicsService:CollisionGroupSetCollidable(GROUP_MOVING, GROUP_MOVING, false)
	PhysicsService:CollisionGroupSetCollidable(GROUP_MOVING, GROUP_IDLE, false)
	PhysicsService:CollisionGroupSetCollidable(GROUP_MOVING, "Default", false)
	PhysicsService:CollisionGroupSetCollidable(GROUP_IDLE, GROUP_IDLE, true)
end

local function setGroup(character, group)
	for _, d in ipairs(character:GetDescendants()) do
		if d:IsA("BasePart") then d.CollisionGroup = group end
	end
end

-- ===== Posisi =====
local function standPosition(tileIndex, character)
	local tile = BoardConfig.getTilePart(tileIndex)
	if not tile then return nil end
	local hum = character:FindFirstChildOfClass("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local offset = 3
	if hum and hrp and hum.RigType == Enum.HumanoidRigType.R15 then
		offset = hum.HipHeight + hrp.Size.Y / 2
	end
	return Vector3.new(tile.Position.X, tile.Position.Y + tile.Size.Y / 2 + offset, tile.Position.Z)
end

local function placeAtTile(player, index)
	local character = player.Character
	if not character or not character.Parent then return end
	local pos = standPosition(index, character)
	if pos then character:PivotTo(CFrame.new(pos)) end
end

function MovementEngine.getTile(player)
	return tileOf[player.UserId] or START_TILE
end

function MovementEngine.isMoving(player)
	return moving[player.UserId] == true
end

-- ===== Path =====
-- Normal dice movement selalu Forward.
function MovementEngine.forwardPath(from, steps)
	local path, idx = {}, from
	for _ = 1, steps do
		idx = (idx + 1) % TILE_COUNT
		table.insert(path, idx)
	end
	return path
end

function MovementEngine.backwardPath(from, steps)
	local path, idx = {}, from
	for _ = 1, steps do
		idx = (idx - 1) % TILE_COUNT
		table.insert(path, idx)
	end
	return path
end

-- Forced movement ke destination: jalur terpendek, jarak sama -> Forward.
function MovementEngine.shortestPath(from, to)
	local fwd = (to - from) % TILE_COUNT
	local bwd = (from - to) % TILE_COUNT
	if fwd == 0 then return {} end
	if fwd <= bwd then
		return MovementEngine.forwardPath(from, fwd)
	end
	return MovementEngine.backwardPath(from, bwd)
end

-- ===== Jalan mengikuti polyline tile =====
local function walk(player, character, humanoid, hrp, path)
	local points = { hrp.Position }
	for _, idx in ipairs(path) do
		local p = standPosition(idx, character)
		if not p then return false end
		table.insert(points, p)
	end

	local seg, total = {}, 0
	for i = 2, #points do
		seg[i] = (points[i] - points[i - 1]).Magnitude
		total += seg[i]
	end

	local speed = BASE_SPEED * (1 + math.clamp((#path - 12) / 30, 0, LONG_TRIP_BOOST))
	local flat = Vector3.new(1, 0, 1)
	local facing = hrp.CFrame.LookVector * flat
	if facing.Magnitude < 0.01 then facing = Vector3.new(0, 0, -1) end
	facing = facing.Unit

	local dist, done, ok = 0, false, true
	local conn
	conn = RunService.Heartbeat:Connect(function(dt)
		if done then return end
		if not character.Parent or not hrp.Parent or not player.Parent
			or humanoid.Health <= 0 or not GameState.isRunning() then
			ok, done = false, true
			return
		end
		dist = math.min(dist + speed * dt, total)

		local acc, i = 0, 2
		while i < #points and acc + seg[i] < dist do
			acc += seg[i]
			i += 1
		end
		local a, b = points[i - 1], points[i]
		local alpha = seg[i] > 0 and (dist - acc) / seg[i] or 1
		local pos = a:Lerp(b, alpha)

		local dir = (b - a) * flat
		if dir.Magnitude > 0.01 then
			local blended = facing:Lerp(dir.Unit, 1 - math.exp(-TURN_SMOOTHING * dt))
			if blended.Magnitude > 0.01 then facing = blended.Unit end
		end

		hrp.CFrame = CFrame.lookAt(pos, pos + facing)
		if dist >= total then done = true end
	end)

	while not done do task.wait() end
	conn:Disconnect()
	return ok
end

-- ===== Execute movement =====
-- Mengembalikan { ok, from, to, zeroEntries, landedOnStart, path, reason }
function MovementEngine.moveAlong(player, path)
	local userId = player.UserId
	local from = tileOf[userId] or START_TILE
	local result = { ok = false, from = from, to = path[#path], zeroEntries = 0, landedOnStart = false, path = path }

	local gateOk, why = GameState.gate()
	if not gateOk then result.reason = why return result end
	if #path == 0 then result.reason = "EMPTY_PATH" return result end
	if moving[userId] then result.reason = "ALREADY_MOVING" return result end

	for _, idx in ipairs(path) do
		if idx == START_TILE then result.zeroEntries += 1 end
	end
	result.landedOnStart = (result.to == START_TILE)

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not (humanoid and hrp and humanoid.Health > 0) then
		result.reason = "NO_CHARACTER"
		return result
	end

	moving[userId] = true

	local slotColor = GameState.getSlotColor(userId)
	local arrow = ArrowIndicator.show(result.to, slotColor and slotColor.color)

	setGroup(character, GROUP_MOVING)
	hrp.Anchored = true
	task.wait(PRE_DELAY)

	StartWalkAnim:FireClient(player)
	local walked = walk(player, character, humanoid, hrp, path)
	StopWalkAnim:FireClient(player)

	ArrowIndicator.clear(arrow)
	moving[userId] = nil

	if character.Parent and hrp.Parent then
		hrp.Anchored = false
		setGroup(character, GROUP_IDLE)
	end

	if not walked then
		-- Movement dibatalkan (reset/death/disconnect/Game End): kembali ke last valid state.
		if GameState.isRunning() then placeAtTile(player, from) end
		result.reason = "CANCELLED"
		return result
	end

	tileOf[userId] = result.to
	player:SetAttribute("TileIndex", result.to)
	result.ok = true
	return result
end

function MovementEngine.moveSteps(player, steps)
	return MovementEngine.moveAlong(player, MovementEngine.forwardPath(MovementEngine.getTile(player), steps))
end

-- ===== Spawn / lifecycle =====
local function onCharacterAdded(player, character)
	character:WaitForChild("HumanoidRootPart", 10)
	task.wait(0.5)
	if tileOf[player.UserId] == nil then tileOf[player.UserId] = START_TILE end
	player:SetAttribute("TileIndex", tileOf[player.UserId])
	setGroup(character, GROUP_IDLE)
	placeAtTile(player, tileOf[player.UserId])
end

function MovementEngine.init()
	setupGroups()
	local function hook(player)
		player.CharacterAdded:Connect(function(c) task.spawn(onCharacterAdded, player, c) end)
		if player.Character then task.spawn(onCharacterAdded, player, player.Character) end
	end
	for _, p in ipairs(Players:GetPlayers()) do hook(p) end
	Players.PlayerAdded:Connect(hook)
	Players.PlayerRemoving:Connect(function(p)
		tileOf[p.UserId] = nil
		moving[p.UserId] = nil
	end)
end

return MovementEngine
