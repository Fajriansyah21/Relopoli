-- LocalScript: StarterCharacterScripts > WalkAnimController
-- Trigger animasi jalan secara manual saat server minta

local RS = game:GetService("ReplicatedStorage")
local RemoteEvents  = RS:WaitForChild("RemoteEvents")
local StartWalkAnim = RemoteEvents:WaitForChild("StartWalkAnim")
local StopWalkAnim  = RemoteEvents:WaitForChild("StopWalkAnim")

local character = script.Parent
local humanoid  = character:WaitForChild("Humanoid")
local animator  = humanoid:WaitForChild("Animator")

-- Ambil animasi Walk dari Animate script bawaan Roblox
local walkAnim = nil
local walkTrack = nil

-- Cari AnimationId walk dari Animate LocalScript bawaan
local function getWalkAnimation()
	local animateScript = character:FindFirstChild("Animate")
	if not animateScript then return nil end

	local walkFolder = animateScript:FindFirstChild("walk")
	if not walkFolder then return nil end

	local walkAnimInstance = walkFolder:FindFirstChildOfClass("Animation")
	if not walkAnimInstance then return nil end

	return walkAnimInstance
end

local function startWalk()
	if walkTrack and walkTrack.IsPlaying then return end

	local animInstance = getWalkAnimation()
	if animInstance then
		walkTrack = animator:LoadAnimation(animInstance)
		walkTrack:Play()
		print("🚶 Animasi jalan dimulai")
	else
		print("⚠️ Animasi walk tidak ditemukan")
	end
end

local function stopWalk()
	if walkTrack and walkTrack.IsPlaying then
		walkTrack:Stop()
		print("🛑 Animasi jalan dihentikan")
	end
end

StartWalkAnim.OnClientEvent:Connect(startWalk)
StopWalkAnim.OnClientEvent:Connect(stopWalk)