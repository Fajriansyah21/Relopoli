-- DiceSystem (Script - Server): dadu fisik + pembacaan VisionDice (sistem lama dipertahankan).
-- Perubahan dari versi lama:
--  * Hanya dipicu server lewat DiceBridge (client tidak bisa memicu dadu langsung).
--  * Hasil tidak valid (belum berhenti / face tidak terbaca) -> lempar ulang, TANPA math.random.
--  * Hasil valid diserahkan ke DiceBridge; keputusan Double/Movement ada di RollFlow.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local DiceBridge = require(SSS.Core.DiceBridge)
local DiceResultEvent = RS:WaitForChild("RemoteEvents"):WaitForChild("DiceResult")

local Dice = workspace:WaitForChild("Board1"):WaitForChild("Dice")
local Dice1       = Dice:WaitForChild("Dice1")
local Dice2       = Dice:WaitForChild("Dice2")
local MunculDice1 = Dice:WaitForChild("MunculDice1")
local MunculDice2 = Dice:WaitForChild("MunculDice2")
local VisionDice  = Dice:WaitForChild("VisionDice")

-- VisionDice sebagai referensi arah "atas": face dadu yang menghadap VisionDice (dot product)
local function isSide(facing, p2pVec)
	local angle = math.acos(math.clamp(facing:Dot(p2pVec), -1, 1))
	return math.deg(angle) < 45
end

-- Mengembalikan 1..6, atau nil kalau face atas tidak bisa dipastikan (hasil tidak valid)
local function readTopFace(dicePart)
	local p2pVec = (VisionDice.Position - dicePart.Position).Unit

	if isSide(dicePart.CFrame.LookVector, p2pVec)   then return 2 end
	if isSide(-dicePart.CFrame.LookVector, p2pVec)  then return 5 end
	if isSide(dicePart.CFrame.RightVector, p2pVec)  then return 3 end
	if isSide(-dicePart.CFrame.RightVector, p2pVec) then return 4 end
	if isSide(-dicePart.CFrame.UpVector, p2pVec)    then return 6 end
	if isSide(dicePart.CFrame.UpVector, p2pVec)     then return 1 end

	return nil
end

-- Reset dadu ke posisi MunculDice, pertahankan rotasi terakhir
local function resetDice()
	Dice1.Anchored = true
	Dice2.Anchored = false

	local rot1 = Dice1.CFrame - Dice1.CFrame.Position
	local rot2 = Dice2.CFrame - Dice2.CFrame.Position

	Dice1.CFrame = CFrame.new(MunculDice1.Position) * rot1
	Dice2.CFrame = CFrame.new(MunculDice2.Position) * rot2

	Dice1.Anchored = true
	Dice2.Anchored = true

	Dice1.AssemblyLinearVelocity  = Vector3.zero
	Dice1.AssemblyAngularVelocity = Vector3.zero
	Dice2.AssemblyLinearVelocity  = Vector3.zero
	Dice2.AssemblyAngularVelocity = Vector3.zero
end

local function applyForce(d)
	d.AssemblyLinearVelocity = Vector3.new(math.random(-5, 5), -30, math.random(-5, 5))
	d.AssemblyAngularVelocity = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
end

-- Satu kali lempar: tunggu dadu benar-benar berhenti (maks 4 detik), anchor, lalu baca
local function throwDice()
	Dice1.Anchored = false
	Dice2.Anchored = false
	applyForce(Dice1)
	applyForce(Dice2)

	local elapsed, settled = 0, false
	while elapsed < 4 do
		task.wait(0.1)
		elapsed += 0.1
		if Dice1.AssemblyLinearVelocity.Magnitude < 0.5 and Dice2.AssemblyLinearVelocity.Magnitude < 0.5
			and Dice1.AssemblyAngularVelocity.Magnitude < 0.5 and Dice2.AssemblyAngularVelocity.Magnitude < 0.5 then
			settled = true
			break
		end
	end

	Dice1.Anchored = true
	Dice2.Anchored = true
	task.wait(0.2)

	return settled, readTopFace(Dice1), readTopFace(Dice2)
end

local isRolling = false

local function performRoll(player)
	while isRolling do task.wait(0.1) end -- antre: tidak ada dua lemparan bersamaan
	isRolling = true

	local die1, die2
	local attempts = 0
	repeat
		attempts += 1
		local settled, a, b = throwDice()
		if settled and a and b then
			die1, die2 = a, b
		else
			warn(("[DiceSystem] Hasil tidak valid (attempt %d), lempar ulang"):format(attempts))
			resetDice()
			task.wait(0.5)
		end
	until die1

	DiceResultEvent:FireAllClients(die1, die2, die1 + die2)
	DiceBridge.deliver(player, die1, die2)

	task.wait(3)
	resetDice()
	isRolling = false
end

DiceBridge.RollRequested:Connect(function(player)
	task.spawn(performRoll, player)
end)

resetDice()
print("[DiceSystem] aktif (dipicu DiceBridge)")
