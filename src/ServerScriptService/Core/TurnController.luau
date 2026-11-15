-- TurnController (server-only): otoritas pusat alur Turn dan resolution.
-- Sistem lain menyerahkan hasil ke sini; hanya controller yang menyelesaikan Turn.

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")

local Constants = require(RS.Modules.Constants)
local GameState = require(SSS.Core.GameState)

local Phase = Constants.Phase
local Result = Constants.Result

local TurnController = {}

local currentUserId = nil
local currentPhase = Phase.IDLE
local currentSubstate = nil
local turnNumber = 0
local doubleCounter = 0
local rollsStartedThisTurn = 0
local storedNewsUsedThisTurn = 0
local secondLifeUsed = {} -- game-level, per player; tidak direset pada Turn baru
local rollInFlight = false
local rollAgainChoice = nil
local rollAgainRollPending = false
local timingValidators = {}
local storedNewsUseInProgress = false
local resolutionSequence = 0
local activeResolution = nil

local rollApproved = Instance.new("BindableEvent")
TurnController.RollApproved = rollApproved.Event -- (player, rollContext?)
local turnBegan = Instance.new("BindableEvent")
TurnController.TurnBegan = turnBegan.Event -- (userId, turnNumber)
local rollAgainChoiceClosed = Instance.new("BindableEvent")
TurnController.RollAgainChoiceClosed = rollAgainChoiceClosed.Event -- (token, reason)
local resolutionContinued = Instance.new("BindableEvent")
TurnController.ResolutionContinued = resolutionContinued.Event -- (contextId, resumeKey, resumeData, result)
local resolutionClosed = Instance.new("BindableEvent")
TurnController.ResolutionClosed = resolutionClosed.Event -- (contextId, reason, result)
local flowCancelled = Instance.new("BindableEvent")
TurnController.FlowCancelled = flowCancelled.Event -- (reason)

local function snapshot()
	return {
		userId = currentUserId,
		phase = currentPhase,
		substate = currentSubstate,
		turn = turnNumber,
		doubleCounter = doubleCounter,
		storedNewsUsed = storedNewsUsedThisTurn,
		gameState = GameState.get(),
		resolutionId = activeResolution and activeResolution.id or nil,
	}
end

local function broadcast()
	local remotes = RS:FindFirstChild("RemoteEvents")
	local ev = remotes and remotes:FindFirstChild("TurnChanged")
	if ev then ev:FireAllClients(snapshot()) end
end

function TurnController.sendStateTo(player)
	local remotes = RS:FindFirstChild("RemoteEvents")
	local ev = remotes and remotes:FindFirstChild("TurnChanged")
	if ev and typeof(player) == "Instance" then ev:FireClient(player, snapshot()) end
end

local function setPhase(p)
	if not GameState.isRunning() then return false end
	currentPhase = p
	broadcast()
	return true
end

local function combine(a, b)
	return GameState.combineResults(a or Result.CONTINUE, b or Result.CONTINUE)
end

local function clearResolution(reason, result)
	local context = activeResolution
	local hadPendingFlow = context ~= nil or rollAgainChoice ~= nil
		or currentSubstate ~= nil or rollAgainRollPending or rollInFlight
	activeResolution = nil
	currentSubstate = nil
	if context then
		context.cancelled = true
		resolutionClosed:Fire(context.id, reason, result)
	end
	if rollAgainChoice then
		local token = rollAgainChoice.token
		rollAgainChoice = nil
		rollAgainChoiceClosed:Fire(token, reason)
	end
	rollAgainRollPending = false
	if hadPendingFlow then flowCancelled:Fire(reason) end
end

local function hardStop(reason)
	clearResolution(reason or "GAME_END", Result.GAME_END)
	rollInFlight = false
	currentPhase = Phase.IDLE
	broadcast()
	return Result.GAME_END
end

-- ===== Query =====
function TurnController.getCurrentUserId() return currentUserId end
function TurnController.getPhase() return currentPhase end
function TurnController.getSubstate() return currentSubstate end
function TurnController.getTurnNumber() return turnNumber end
function TurnController.getDoubleCounter() return doubleCounter end
function TurnController.getStoredNewsUsedThisTurn() return storedNewsUsedThisTurn end
function TurnController.hasUsedSecondLife(userId) return secondLifeUsed[userId] == true end

function TurnController.isCurrentPlayer(player)
	return player ~= nil and currentUserId == player.UserId
end

-- ===== Giliran =====
local function nextActiveUserId()
	local active = GameState.getActiveUserIds()
	if #active == 0 then return nil end
	if not currentUserId then return active[1] end
	local full = GameState.getOrder()
	local idx = table.find(full, currentUserId) or 0
	for step = 1, #full do
		local candidate = full[((idx - 1 + step) % #full) + 1]
		if GameState.isActive(candidate) and Players:GetPlayerByUserId(candidate) then
			return candidate
		end
	end
	return nil
end

function TurnController.beginTurn(userId)
	if not GameState.isRunning() then return false end
	clearResolution("NEW_TURN")
	currentUserId = userId
	turnNumber += 1
	doubleCounter = 0
	rollsStartedThisTurn = 0
	storedNewsUsedThisTurn = 0
	rollInFlight = false
	setPhase(Phase.TURN_START)
	turnBegan:Fire(userId, turnNumber)
	setPhase(Phase.NEWS_PHASE)
	return true
end

function TurnController.endTurn()
	if not GameState.isRunning() then return false end
	clearResolution("TURN_END")
	setPhase(Phase.TURN_END)
	doubleCounter = 0
	rollsStartedThisTurn = 0
	rollInFlight = false
	local nextId = nextActiveUserId()
	if not nextId then
		currentPhase = Phase.IDLE
		broadcast()
		return false
	end
	return TurnController.beginTurn(nextId)
end

function TurnController.start()
	if currentUserId ~= nil then return false end
	local active = GameState.getActiveUserIds()
	if #active < 1 then return false end
	return TurnController.beginTurn(active[1])
end

-- ===== Stored News timing and atomic usage ledger =====
local function validateStoredTiming(player, timing, token, context)
	if timing == "NEWS_PHASE" then
		return currentPhase == Phase.NEWS_PHASE and currentSubstate == nil, "WRONG_PHASE"
	elseif timing == "ROLL_AGAIN" then
		return rollAgainChoice ~= nil and rollAgainChoice.playerUserId == player.UserId
			and rollAgainChoice.token == token and currentSubstate == "ROLL_AGAIN_CHOICE_PENDING", "WRONG_TIMING"
	elseif timing == "JAIL_BREAK" or timing == "SECOND_LIFE" then
		local validator = timingValidators[timing]
		if not validator then return false, "TIMING_NOT_ENABLED" end
		local ok, valid, why = pcall(validator, player, context)
		if not ok then return false, "TIMING_VALIDATION_FAILED" end
		return valid == true, why or "WRONG_TIMING"
	end
	return false, "INVALID_TIMING"
end

function TurnController.registerStoredNewsTimingValidator(timing, validator)
	if (timing ~= "JAIL_BREAK" and timing ~= "SECOND_LIFE") or type(validator) ~= "function" then
		return false, "INVALID_VALIDATOR"
	end
	if timingValidators[timing] then return false, "VALIDATOR_ALREADY_REGISTERED" end
	timingValidators[timing] = validator
	return true
end

function TurnController.canBeginStoredNewsUse(player, timing, token, context)
	local ok, why = GameState.gate()
	if not ok then return false, why end
	if not player or not GameState.isActive(player) then return false, "NOT_ACTIVE" end
	if timing ~= "SECOND_LIFE" and not TurnController.isCurrentPlayer(player) then
		return false, "NOT_YOUR_TURN"
	end
	local timingOk, timingWhy = validateStoredTiming(player, timing, token, context)
	if not timingOk then return false, timingWhy end
	if timing == "SECOND_LIFE" then
		if secondLifeUsed[player.UserId] then return false, "SECOND_LIFE_ALREADY_USED" end
	elseif storedNewsUsedThisTurn >= Constants.MAX_STORED_NEWS_PER_TURN then
		return false, "NEWS_LIMIT"
	end
	return true
end

-- consumeCard wajib server-side, non-yielding, dan melakukan satu mutasi inventory atomik.
-- Counter/flag hanya berubah setelah callback mengonfirmasi kartu berhasil dikonsumsi.
function TurnController.beginStoredNewsUse(player, cardId, timing, consumeCard, token, context)
	if storedNewsUseInProgress then return false, "USE_IN_PROGRESS" end
	if type(consumeCard) ~= "function" then return false, "MISSING_CONSUMER" end
	if timing == "ROLL_AGAIN" and (not rollAgainChoice or rollAgainChoice.cardId ~= cardId) then
		return false, "CARD_MISMATCH"
	end
	local ok, why = TurnController.canBeginStoredNewsUse(player, timing, token, context)
	if not ok then return false, why end
	if (timing == "NEWS_PHASE" or timing == "JAIL_BREAK")
		and (not activeResolution or activeResolution.userId ~= player.UserId
			or activeResolution.turn ~= turnNumber) then
		return false, "NO_ACTIVE_CONTINUATION"
	end

	-- Lock stays held through a yielding or reentrant callback so no second use can
	-- consume another card against the same per-turn slot before this commit settles.
	storedNewsUseInProgress = true
	local callOk, consumed, consumeWhy = pcall(consumeCard, player, cardId)
	storedNewsUseInProgress = false
	if not callOk then return false, "CONSUME_FAILED" end
	if consumed ~= true then return false, consumeWhy or "CARD_NOT_AVAILABLE" end

	if timing == "SECOND_LIFE" then
		secondLifeUsed[player.UserId] = true
	else
		storedNewsUsedThisTurn += 1
		if timing == "NEWS_PHASE" or timing == "JAIL_BREAK" then
			currentSubstate = "NEWS_EFFECT_RESOLVING"
			setPhase(Phase.SPECIAL_RESOLUTION)
		end
	end
	return true
end

-- ===== Roll request (intent dari client) =====
function TurnController.requestRoll(player)
	local ok, why = GameState.gate()
	if not ok then return false, why end
	if not player or not GameState.isActive(player) then return false, "NOT_ACTIVE" end
	if not TurnController.isCurrentPlayer(player) then return false, "NOT_YOUR_TURN" end
	if currentPhase ~= Phase.NEWS_PHASE and currentPhase ~= Phase.EXTRA_ROLL_CHECK then
		return false, "WRONG_PHASE"
	end
	if currentSubstate ~= nil then return false, "RESOLUTION_PENDING" end
	if rollInFlight then return false, "ROLL_IN_PROGRESS" end
	rollInFlight = true
	rollsStartedThisTurn += 1
	setPhase(Phase.ROLL)
	rollApproved:Fire(player, { rollAgain = false })
	return true
end

function TurnController.canOfferRollAgain(player)
	return GameState.isRunning()
		and player ~= nil
		and GameState.isActive(player)
		and TurnController.isCurrentPlayer(player)
		and currentPhase == Phase.DICE_RESOLUTION
		and currentSubstate == nil
		and rollsStartedThisTurn == 1
		and storedNewsUsedThisTurn < Constants.MAX_STORED_NEWS_PER_TURN
end

function TurnController.beginRollAgainChoice(player, cardId)
	if not TurnController.canOfferRollAgain(player) then return false, "ROLL_AGAIN_UNAVAILABLE" end
	resolutionSequence += 1
	local token = resolutionSequence
	rollAgainChoice = { token = token, playerUserId = player.UserId, cardId = cardId }
	currentSubstate = "ROLL_AGAIN_CHOICE_PENDING"
	setPhase(Phase.SPECIAL_RESOLUTION)
	return true, token
end

-- decision: "KEEP" atau "REROLL". REROLL mengonsumsi kartu dan slot sebelum
-- mengotorisasi Roll #2. Pemanggil hanya boleh memberi callback konsumsi server-side.
function TurnController.finishRollAgainChoice(player, token, decision, consumeCard)
	if not player or not GameState.isActive(player) or not TurnController.isCurrentPlayer(player) then
		return false, "NOT_CURRENT_PLAYER"
	end
	if not rollAgainChoice or rollAgainChoice.token ~= token
		or rollAgainChoice.playerUserId ~= player.UserId
		or currentSubstate ~= "ROLL_AGAIN_CHOICE_PENDING" then
		return false, "STALE_CHOICE"
	end

	if decision == "KEEP" then
		rollAgainChoice = nil
		currentSubstate = nil
		setPhase(Phase.DICE_RESOLUTION)
		rollAgainChoiceClosed:Fire(token, "KEPT_ROLL_1")
		return true
	elseif decision ~= "REROLL" then
		return false, "INVALID_DECISION"
	end

	local ok, why = TurnController.beginStoredNewsUse(
		player, rollAgainChoice.cardId, "ROLL_AGAIN", consumeCard, token
	)
	if not ok then return false, why end

	rollAgainChoice = nil
	currentSubstate = nil
	rollAgainRollPending = true
	rollInFlight = true
	rollsStartedThisTurn += 1
	setPhase(Phase.ROLL)
	rollAgainChoiceClosed:Fire(token, "REROLL_CONFIRMED")
	rollApproved:Fire(player, { rollAgain = true })
	return true
end

-- Dipanggil sekali oleh RollFlow untuk hasil dadu yang sudah lolos validasi.
function TurnController.takeRollContext(player)
	if not player or not TurnController.isCurrentPlayer(player) or currentPhase ~= Phase.ROLL then
		return nil
	end
	local context = { rollAgain = rollAgainRollPending }
	rollAgainRollPending = false
	return context
end

-- ===== Double Counter =====
function TurnController.registerDouble()
	doubleCounter += 1
	broadcast()
	return doubleCounter, doubleCounter >= Constants.DOUBLE_LIMIT
end

-- ===== Resolution continuation =====
function TurnController.beginResolutionContext(player, resumeKey, resumeData)
	if not GameState.isRunning() then return nil, "GAME_ENDED" end
	if not player or not TurnController.isCurrentPlayer(player) then return nil, "NOT_YOUR_TURN" end
	if activeResolution then return nil, "RESOLUTION_ALREADY_ACTIVE" end
	resolutionSequence += 1
	activeResolution = {
		id = resolutionSequence,
		userId = player.UserId,
		turn = turnNumber,
		resumeKey = resumeKey,
		resumeData = resumeData,
		pendingResult = Result.CONTINUE,
		cardResult = Result.CONTINUE,
		awaitingAck = nil,
		startedEffects = {},
		cancelled = false,
	}
	broadcast()
	return activeResolution.id
end

function TurnController.getResolutionContext(player)
	local c = activeResolution
	if not c or c.cancelled or (player and c.userId ~= player.UserId) then return nil end
	return {
		id = c.id, userId = c.userId, turn = c.turn,
		resumeKey = c.resumeKey, resumeData = c.resumeData,
		pendingResult = c.pendingResult, awaitingAck = c.awaitingAck,
	}
end

function TurnController.setResolutionCheckpoint(contextId, resumeKey, resumeData)
	local c = activeResolution
	if not c or c.id ~= contextId or c.cancelled or c.awaitingAck then return false, "NO_ACTIVE_CONTINUATION" end
	c.resumeKey, c.resumeData = resumeKey, resumeData
	return true
end

function TurnController.beginNewsEffect(contextId, effectId)
	local c = activeResolution
	if not c or c.id ~= contextId or c.cancelled or c.awaitingAck then return false, "NO_ACTIVE_CONTINUATION" end
	if type(effectId) ~= "string" or effectId == "" then return false, "INVALID_EFFECT_ID" end
	if c.startedEffects[effectId] then return false, "DUPLICATE_EFFECT" end
	c.startedEffects[effectId] = true
	currentSubstate = "NEWS_EFFECT_RESOLVING"
	setPhase(Phase.SPECIAL_RESOLUTION)
	return true
end

local function applyFinalResult(result)
	if not GameState.isRunning() then return hardStop("GAME_END") end
	if result == Result.GAME_END then
		clearResolution("GAME_END", result)
		rollInFlight = false
		currentPhase = Phase.IDLE
		broadcast()
	elseif result == Result.PLAYER_ELIMINATED then
		clearResolution("PLAYER_ELIMINATED", result)
		TurnController.endTurn()
	elseif result == Result.TURN_END then
		clearResolution("TURN_END", result)
		TurnController.endTurn()
	elseif result == Result.EXTRA_ROLL then
		clearResolution("EXTRA_ROLL", result)
		rollInFlight = false
		setPhase(Phase.EXTRA_ROLL_CHECK)
	else
		-- CONTINUE: pemanggil meneruskan chain; tidak kembali otomatis ke NEWS_PHASE.
	end
	return result
end

function TurnController.completeNewsEffect(contextId, effectId, result, ackId)
	local c = activeResolution
	if not c or c.id ~= contextId or c.cancelled or not c.startedEffects[effectId] then
		return false, "NO_ACTIVE_EFFECT"
	end
	result = result or Result.CONTINUE
	c.pendingResult = combine(c.pendingResult, result)
	c.cardResult = result

	if result == Result.GAME_END or result == Result.PLAYER_ELIMINATED or not GameState.isRunning() then
		local final = not GameState.isRunning() and Result.GAME_END or result
		clearResolution(final, final)
		return applyFinalResult(final)
	end

	resolutionSequence += 1
	c.awaitingAck = ackId or resolutionSequence
	currentSubstate = "NEWS_ACK_PENDING"
	setPhase(Phase.SPECIAL_RESOLUTION)
	return true, c.awaitingAck
end

function TurnController.acknowledgeNews(player, contextId, ackId)
	local c = activeResolution
	if not c or c.cancelled or c.id ~= contextId or c.userId ~= (player and player.UserId)
		or not c.awaitingAck or c.awaitingAck ~= ackId then
		return false, "STALE_ACK"
	end
	if not GameState.isRunning() then return hardStop("GAME_END") end

	c.awaitingAck = nil
	c.cardResult = Result.CONTINUE
	currentSubstate = nil

	-- Ack resumes the saved continuation for every non-terminal result. The
	-- continuation decides whether a chain remains; finishResolution applies the
	-- accumulated priority result only after that chain is complete.
	resolutionContinued:Fire(c.id, c.resumeKey, c.resumeData, c.pendingResult)
	broadcast()
	return true, c.pendingResult
end

function TurnController.finishResolution(contextId, result)
	local c = activeResolution
	if not c or c.id ~= contextId or c.cancelled then return false, "NO_ACTIVE_CONTINUATION" end
	result = result or Result.CONTINUE
	c.pendingResult = combine(c.pendingResult, result)

	if not GameState.isRunning() then return hardStop("GAME_END") end
	if c.pendingResult == Result.GAME_END or c.pendingResult == Result.PLAYER_ELIMINATED then
		local final = c.pendingResult
		clearResolution(final, final)
		return applyFinalResult(final)
	end
	if c.awaitingAck then return true, "PENDING_ACK" end

	local final = c.pendingResult
	clearResolution("RESOLUTION_COMPLETE", final)
	return applyFinalResult(final)
end

-- ===== Resolution Result =====
-- API lama dipertahankan; RollFlow memakai finishResolution untuk context baru.
function TurnController.resolve(result, contextId)
	if contextId then return TurnController.finishResolution(contextId, result) end
	if not GameState.isRunning() then return hardStop("GAME_END") end
	return applyFinalResult(result or Result.CONTINUE)
end

function TurnController.advance(phase)
	return setPhase(phase)
end

GameState.Changed:Connect(function()
	if not GameState.isRunning() then
		hardStop("GAME_END")
		return
	end
	local affectedUserId = currentUserId
	if affectedUserId and not GameState.isActive(affectedUserId) then
		task.defer(function()
			if GameState.isRunning() and currentUserId == affectedUserId and not GameState.isActive(affectedUserId) then
				TurnController.resolve(Result.PLAYER_ELIMINATED)
			end
		end)
	end
end)

return TurnController
