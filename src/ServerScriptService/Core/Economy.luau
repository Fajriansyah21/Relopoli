-- Economy (server-only): Balance, Payment, Shield, Second Life, Bankruptcy pipeline.
-- Semua nominal kelipatan 500 Rels. Semua fungsi lewat Game State Gate + validasi aktor.
-- Pipeline negatif: Negative Balance -> Bankruptcy Check -> Second Life? -> Asset Liquidation -> Final Bankruptcy.
-- STATUS: Asset Liquidation memakai provider (dipasang fase Property/UI). Tanpa provider = tidak ada aset yang bisa dijual.
-- Tenant Final Bankruptcy saat bayar kewajiban: penerima TETAP menerima jumlah penuh.
--   Kekurangan (uang tenant + hasil likuidasi tidak cukup) ditanggung Bank; tidak dibebankan ke pemain lain.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Constants = require(RS.Modules.Constants)
local GameState = require(SSS.Core.GameState)

local Result = Constants.Result
local UNIT = Constants.CURRENCY_UNIT

local Economy = {}

local balances = {}     -- [userId] = Rels
local shields = {}      -- [userId] = jumlah Shield
local secondLives = {}  -- [userId] = true (Stored News Second Life dimiliki)

local liquidationProvider = nil -- { hasAssets = function(userId) -> bool, sellOne = function(userId) -> bool }

local eliminated = Instance.new("BindableEvent")
Economy.Eliminated = eliminated.Event -- (userId) Final Bankruptcy

local function publish(userId)
	local p = Players:GetPlayerByUserId(userId)
	if p then
		p:SetAttribute("Rels", balances[userId])      -- direplikasi ke client hanya untuk UI
		p:SetAttribute("Shield", shields[userId] or 0)
	end
end

local function validAmount(a)
	return typeof(a) == "number" and a == a and a > 0 and a < math.huge and a % UNIT == 0
end

local function canAct(userId)
	local ok, why = GameState.gate()
	if not ok then return false, why end
	if balances[userId] == nil then return false, "NO_ACCOUNT" end
	if not GameState.isActive(userId) then return false, "NOT_ACTIVE" end
	return true
end

-- Pembulatan nominal ekonomi ke kelipatan 500 (setengah naik: 6.750 -> 7.000)
function Economy.roundToUnit(x)
	return math.floor(x / UNIT + 0.5) * UNIT
end

-- ===== Account =====
function Economy.ensure(userId)
	if balances[userId] == nil then
		balances[userId] = Constants.STARTING_CAPITAL
		shields[userId] = 0
		publish(userId)
	end
	return balances[userId]
end

function Economy.getBalance(userId) return balances[userId] end
function Economy.getShields(userId) return shields[userId] or 0 end
function Economy.hasSecondLife(userId) return secondLives[userId] == true end

function Economy.grantShield(userId, n)
	if balances[userId] == nil or not GameState.isRunning() then return false end
	shields[userId] = (shields[userId] or 0) + (n or 1)
	publish(userId)
	return true
end

-- Dipanggil sistem News saat Second Life masuk inventory pemain (Stored, 1 copy).
function Economy.grantSecondLife(userId)
	if balances[userId] == nil or not GameState.isRunning() then return false end
	secondLives[userId] = true
	return true
end

function Economy.setLiquidationProvider(provider)
	liquidationProvider = provider
end

-- ===== Credit (dari Bank) =====
function Economy.credit(userId, amount, reason)
	local ok, why = canAct(userId)
	if not ok then return false, why end
	if not validAmount(amount) then return false, "INVALID_AMOUNT" end
	balances[userId] += amount
	publish(userId)
	return true, balances[userId]
end

-- ===== Bankruptcy Check (sub-process, bukan Turn baru) =====
-- return recovered(bool), how(string)
local function bankruptcyCheck(userId)
	if balances[userId] >= 0 then return true, "SOLVENT" end

	-- Second Life dicek SEBELUM Asset Liquidation
	if secondLives[userId] then
		secondLives[userId] = nil
		balances[userId] = Constants.SECOND_LIFE_BALANCE -- Balance -> 0 lalu +50.000
		shields[userId] = (shields[userId] or 0) + 1
		publish(userId)
		return true, "SECOND_LIFE"
	end

	-- Asset Liquidation: pemain memilih aset sendiri; berhenti begitu Balance >= 0
	local lp = liquidationProvider
	while balances[userId] < 0 do
		if not GameState.isRunning() then return false, "GAME_ENDED" end
		if not (lp and lp.hasAssets(userId)) then break end
		if not lp.sellOne(userId) then break end
	end
	if balances[userId] >= 0 then return true, "LIQUIDATED" end
	if not GameState.isRunning() then return false, "GAME_ENDED" end

	-- Final Bankruptcy
	GameState.setPlayerState(userId, Constants.PlayerState.ELIMINATED)
	publish(userId)
	eliminated:Fire(userId)
	return false, "FINAL_BANKRUPTCY"
end

-- Dipakai efek yang boleh membuat Balance negatif tanpa lewat pay() (mis. Forced Payment 50K lewat pay allowNegative).
function Economy.bankruptcyCheck(userId)
	local ok, why = canAct(userId)
	if not ok then return false, why end
	return bankruptcyCheck(userId)
end

-- ===== Pay =====
-- opts = {
--   recipients = { {userId=, amount=}, ... }   -- jumlah total harus = amount; kosong = Bank
--   allowNegative = bool                        -- true: efek wajib (Rent, Market Loss, Forced Payment); false: pembayaran sukarela
--   opId = string                               -- efek ekonomi tepat satu kali
-- }
-- return { ok, reason, paid, shielded, result }  (result = Constants.Result untuk Turn Controller)
function Economy.pay(userId, amount, opts)
	opts = opts or {}
	local out = { ok = false, paid = 0, shielded = 0, result = Result.CONTINUE }

	local ok, why = canAct(userId)
	if not ok then out.reason = why; if why == "GAME_ENDED" then out.result = Result.GAME_END end; return out end
	if not validAmount(amount) then out.reason = "INVALID_AMOUNT"; return out end

	local recipients = opts.recipients
	if recipients then
		local sum = 0
		for _, r in ipairs(recipients) do
			if typeof(r) ~= "table" or r.userId == userId or balances[r.userId] == nil
				or not GameState.isActive(r.userId) or not validAmount(r.amount) then
				out.reason = "INVALID_RECIPIENT"; return out
			end
			sum += r.amount
		end
		if sum ~= amount then out.reason = "SPLIT_MISMATCH"; return out end
	end

	local bal = balances[userId]
	if not opts.allowNegative and bal < amount then out.reason = "INSUFFICIENT"; return out end
	if opts.opId and not GameState.claimOperation(opts.opId) then out.reason = "DUPLICATE"; return out end

	out.ok = true
	out.paid = amount
	local settled = true

	if bal >= amount then
		balances[userId] = bal - amount
	elseif (shields[userId] or 0) > 0 then
		-- Shield menyerap bagian yang membuat Balance negatif; pemain tetap kehilangan Balance yang dimiliki
		shields[userId] -= 1
		out.paid = bal
		out.shielded = amount - bal
		balances[userId] = 0
	else
		balances[userId] = bal - amount -- negatif -> Bankruptcy Check
		publish(userId)
		local recovered, how = bankruptcyCheck(userId)
		if not recovered then
			out.reason = how
			if how == "FINAL_BANKRUPTCY" then
				-- penerima tetap dapat penuh; Bank menanggung kekurangan
				local shortfall = math.min(math.max(-balances[userId], 0), amount)
				out.paid = amount - shortfall
				out.bankCovered = shortfall
				out.result = Result.PLAYER_ELIMINATED
			else -- GAME_ENDED: tidak ada perubahan state lagi setelah Game End
				settled = false
				out.paid = 0
				out.result = Result.GAME_END
			end
		end
	end
	publish(userId)

	-- Distribusi Full Rent hanya setelah kemampuan bayar tenant selesai ditentukan
	if settled and recipients then
		for _, r in ipairs(recipients) do
			if balances[r.userId] ~= nil then
				balances[r.userId] += r.amount
				publish(r.userId)
			end
		end
	end
	return out
end

-- Bayar sesuai kemampuan (Generous Neighbor): tidak pernah membuat Balance negatif, tidak memakai Shield.
function Economy.payUpTo(userId, maxAmount, toUserId, opId)
	local out = { ok = false, paid = 0, result = Result.CONTINUE }
	local ok, why = canAct(userId)
	if not ok then out.reason = why; return out end
	if not validAmount(maxAmount) then out.reason = "INVALID_AMOUNT"; return out end
	if toUserId and (toUserId == userId or balances[toUserId] == nil or not GameState.isActive(toUserId)) then
		out.reason = "INVALID_RECIPIENT"; return out
	end
	if opId and not GameState.claimOperation(opId) then out.reason = "DUPLICATE"; return out end
	local pay = math.min(math.max(balances[userId], 0), maxAmount)
	if pay > 0 then
		balances[userId] -= pay
		publish(userId)
		if toUserId then
			balances[toUserId] += pay
			publish(toUserId)
		end
	end
	out.ok, out.paid = true, pay
	return out
end

return Economy
