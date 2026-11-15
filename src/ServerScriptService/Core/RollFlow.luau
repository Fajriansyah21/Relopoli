-- RollFlow (server-only): pipeline tunggal Roll -> Dice Resolution -> Movement -> Start -> Landing -> Result.
-- Roll Again hanya mengubah konteks Double dari hasil dadu; pipeline Roll #2 tetap pipeline ini.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Constants = require(RS.Modules.Constants)
local GameState = require(SSS.Core.GameState)
local TurnController = require(SSS.Core.TurnController)
local DiceBridge = require(SSS.Core.DiceBridge)
local MovementEngine = require(SSS.Core.MovementEngine)
local StartService = require(SSS.Core.StartService)
local LandingResolver = require(SSS.Core.LandingResolver)

local Phase = Constants.Phase
local Result = Constants.Result

local RollFlow = {}

local jailHandler = nil
local rollAgainProvider = nil
local pendingChoices = {}

local choiceRequested = Instance.new("BindableEvent")
RollFlow.RollAgainChoiceRequested = choiceRequested.Event -- (player, token, cardId, die1, die2)

function RollFlow.setJailHandler(fn)
	jailHandler = fn
end

-- Provider server-side; mengembalikan cardId bila Roll Again tersedia di inventory.
function RollFlow.setRollAgainProvider(fn)
	if fn ~= nil and type(fn) ~= "function" then return false, "INVALID_PROVIDER" end
	rollAgainProvider = fn
	return true
end

local function finishContext(contextId, result)
	if contextId then
		return TurnController.finishResolution(contextId, result)
	end
	return TurnController.resolve(result)
end

local function processRoll(player, die1, die2, rollContext)
	if not GameState.isRunning() then return end

	local contextId, contextWhy = TurnController.beginResolutionContext(player, "ROLL_PIPELINE", {
		die1 = die1,
		die2 = die2,
		rollAgain = rollContext.rollAgain == true,
	})
	if not contextId then
		warn("[RollFlow] Resolution context ditolak: " .. tostring(contextWhy))
		return
	end

	TurnController.setResolutionCheckpoint(contextId, "DICE_RESOLUTION", {
		die1 = die1, die2 = die2, rollAgain = rollContext.rollAgain == true,
	})

	-- Roll Again #2 memakai sum dadu, tetapi bukan sumber Double/Triple Double/Extra Roll.
	local diceDouble = die1 == die2
	local countsAsDouble = diceDouble and not rollContext.rollAgain
	if countsAsDouble then
		local _, triple = TurnController.registerDouble()
		if triple then
			TurnController.setResolutionCheckpoint(contextId, "TRIPLE_DOUBLE", {
				die1 = die1, die2 = die2,
			})
			if jailHandler then
				jailHandler(player)
			else
				warn("[RollFlow] UNRESOLVED/BELUM DIIMPLEMENTASI: Jail (Triple Double)")
			end
			finishContext(contextId, Result.TURN_END)
			return
		end
	end

	TurnController.advance(Phase.MOVEMENT)
	TurnController.setResolutionCheckpoint(contextId, "MOVEMENT", {
		die1 = die1, die2 = die2, rollAgain = rollContext.rollAgain == true,
	})
	local move = MovementEngine.moveSteps(player, die1 + die2)
	if not GameState.isRunning() then return end
	if not move.ok then
		-- Movement gagal tetap membatalkan Start, Landing, dan bonus Double.
		finishContext(contextId, Result.TURN_END)
		return
	end

	TurnController.advance(Phase.START_CHECK)
	TurnController.setResolutionCheckpoint(contextId, "START_CHECK", move)
	StartService.resolve(player, move)
	if not GameState.isRunning() then return end

	TurnController.advance(Phase.LANDING)
	TurnController.setResolutionCheckpoint(contextId, "LANDING", move)
	local landing = LandingResolver.resolve(player, move.to, move)
	if not GameState.isRunning() then return end

	TurnController.advance(Phase.VICTORY_CHECK)
	TurnController.setResolutionCheckpoint(contextId, "VICTORY_CHECK", {
		move = move,
		landingResult = landing,
	})

	-- Selalu gabungkan hasil landing dengan kontribusi dadu memakai prioritas locked.
	-- Roll Again hanya meniadakan Extra Roll dari Double dadu; hasil landing tetap dihormati.
	local combined = GameState.combineResults(
		landing,
		countsAsDouble and Result.EXTRA_ROLL or Result.CONTINUE
	)
	if combined == Result.CONTINUE then combined = Result.TURN_END end
	TurnController.setResolutionCheckpoint(contextId, "FINAL_RESULT", {
		move = move,
		landingResult = landing,
		result = combined,
	})
	finishContext(contextId, combined)
end

local function handleRolled(player, die1, die2)
	-- Hasil basi / duplikat / bukan giliran -> abaikan tanpa side effect.
	if not GameState.isRunning() then return end
	if not TurnController.isCurrentPlayer(player) or TurnController.getPhase() ~= Phase.ROLL then return end

	local rollContext = TurnController.takeRollContext(player)
	if not rollContext then return end
	TurnController.advance(Phase.DICE_RESOLUTION)

	if not rollContext.rollAgain and rollAgainProvider
		and TurnController.canOfferRollAgain(player) then
		local providerOk, cardId = pcall(rollAgainProvider, player)
		if providerOk and (type(cardId) == "string" or type(cardId) == "number") then
			local opened, token = TurnController.beginRollAgainChoice(player, cardId)
			if opened then
				pendingChoices[player.UserId] = {
					token = token, cardId = cardId, die1 = die1, die2 = die2,
				}
				choiceRequested:Fire(player, token, cardId, die1, die2)
				return
			end
		elseif not providerOk then
			warn("[RollFlow] Roll Again provider gagal: " .. tostring(cardId))
		end
	end

	processRoll(player, die1, die2, rollContext)
end

-- Dipanggil oleh server-side News/UI adapter setelah pilihan Roll Again.
-- consumeCard wajib menghapus kartu dari inventory secara sinkron dan non-yielding.
function RollFlow.chooseRollAgain(player, token, decision, consumeCard)
	local pending = player and pendingChoices[player.UserId]
	if not pending or pending.token ~= token then return false, "STALE_CHOICE" end

	local ok, why = TurnController.finishRollAgainChoice(
		player, token, decision, consumeCard
	)
	if not ok then return false, why end

	pendingChoices[player.UserId] = nil
	if decision == "KEEP" then
		processRoll(player, pending.die1, pending.die2, { rollAgain = false })
	end
	return true
end

function RollFlow.init()
	TurnController.RollApproved:Connect(function(player)
		DiceBridge.request(player)
	end)

	DiceBridge.Rolled:Connect(function(player, die1, die2)
		task.spawn(handleRolled, player, die1, die2)
	end)

	TurnController.RollAgainChoiceClosed:Connect(function(token)
		for userId, pending in pairs(pendingChoices) do
			if pending.token == token then pendingChoices[userId] = nil end
		end
	end)

	TurnController.FlowCancelled:Connect(function()
		table.clear(pendingChoices)
	end)
end

return RollFlow
