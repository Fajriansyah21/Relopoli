-- StartService (server-only): Start Detection -> First Lap Check -> Start Reward.
-- Dipanggil SETELAH Movement selesai, SEBELUM Landing Resolution.
-- Pass Start = 20K, Landing Start = 30K, First Lap = 100K TOTAL (menggantikan bonus Start pada event tsb).
-- Efek Landing Start Upgrade (1 property, hidden discount ~10%) = fase Property; di sini hanya dilaporkan lewat flag.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Constants = require(RS.Modules.Constants)
local Economy = require(SSS.Core.Economy)

local StartService = {}

local firstLapDone = {} -- [userId] = true

-- Round selesai saat crossing 39 -> 0 (termasuk berhenti di Start). Terjadi SEBELUM Landing Start.
local roundCompleted = Instance.new("BindableEvent")
StartService.RoundCompleted = roundCompleted.Event -- (userId)

-- moveResult: { zeroEntries = jumlah masuk Tile 0 pada path, landedOnStart = bool }
function StartService.resolve(player, moveResult)
	local userId = player.UserId
	local entries = moveResult.zeroEntries or 0
	local out = { reward = 0, landingStart = false, firstLap = false }
	if entries <= 0 then return out end

	local landed = moveResult.landedOnStart == true
	local passes = entries - (landed and 1 or 0)

	for _ = 1, entries do
		roundCompleted:Fire(userId)
	end

	local total = 0
	local function eventReward(normal)
		if not firstLapDone[userId] then
			firstLapDone[userId] = true
			out.firstLap = true
			return Constants.FIRST_LAP_TOTAL
		end
		return normal
	end

	for _ = 1, passes do
		total += eventReward(Constants.PASS_START)
	end
	if landed then
		total += eventReward(Constants.LANDING_START)
		out.landingStart = true
	end

	if total > 0 then
		local ok = Economy.credit(userId, total, "START")
		if ok then out.reward = total end
	end
	return out
end

return StartService
