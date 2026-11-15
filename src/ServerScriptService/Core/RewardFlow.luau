-- RewardFlow (server-only): handler Landing untuk Tile 20 (Reward).
-- Pemain memilih TEPAT 1 Property miliknya (L1-L5) -> Reward Rent Multiplier 3 Round.
--   Belum ada L5 di room: 2x | minimal 1 L5 di room: 3x (ditentukan saat pemilihan).
-- Reward lama pindah ke target baru; timer reset. Prompt wajib diselesaikan (tidak ada Cancel).
-- Golden Pass (Reward aktif turn berikutnya) = fase News.

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Constants = require(RS.Modules.Constants)
local BoardConfig = require(RS.Modules.BoardConfig)
local GameState = require(SSS.Core.GameState)
local LandingResolver = require(SSS.Core.LandingResolver)
local PropertyService = require(SSS.Core.PropertyService)
local ModifierService = require(SSS.Core.ModifierService)
local PropertyFlow = require(SSS.Core.PropertyFlow)

local Result = Constants.Result

local RewardFlow = {}

local function currentMultiplier()
	return PropertyService.countL5Total() > 0 and Constants.REWARD_MULTIPLIER_WITH_L5 or Constants.REWARD_MULTIPLIER
end

local function landing(player, tile)
	local userId = player.UserId
	local tiles = PropertyService.getTilesOf(userId)
	if #tiles > 0 then
		local options = {}
		for _, t in ipairs(tiles) do
			table.insert(options, { tile = t, name = BoardConfig.Tiles[t].name, level = PropertyService.getLevel(t) })
		end
		PropertyFlow.ask(player, "reward_select", tile, { options = options, multiplier = currentMultiplier() })
	end
	if not GameState.isRunning() then return Result.GAME_END end
	return Result.CONTINUE
end

local inited = false
function RewardFlow.init()
	if inited then return end
	inited = true
	LandingResolver.register("Reward", landing)
	PropertyFlow.registerKind("reward_select", function(player, p, data)
		if data.action ~= "select" or typeof(data.tile) ~= "number" then return false, "INVALID_ACTION" end
		return ModifierService.setReward(player.UserId, data.tile, currentMultiplier())
	end, { allowCancel = false })
end

return RewardFlow
