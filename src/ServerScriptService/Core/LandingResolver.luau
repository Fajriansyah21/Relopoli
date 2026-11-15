-- LandingResolver (server-only): router Landing Resolution.
-- Property / Crown / News / Reward / Transport / Jail / Start didaftarkan oleh sistem masing-masing.
-- Handler harus mengembalikan Constants.Result (default CONTINUE).

local RS = game:GetService("ReplicatedStorage")

local Constants = require(RS.Modules.Constants)
local BoardConfig = require(RS.Modules.BoardConfig)

local Result = Constants.Result

local LandingResolver = {}

local handlers = {} -- [tileType] = function(player, tileIndex, tileInfo, ctx) -> Result

function LandingResolver.register(tileType, fn)
	handlers[tileType] = fn
end

function LandingResolver.resolve(player, tileIndex, ctx)
	local info = BoardConfig.getTile(tileIndex)
	if not info then
		warn(("[Landing] Tile %s tidak ada di BoardConfig"):format(tostring(tileIndex)))
		return Result.CONTINUE
	end
	local fn = handlers[info.type]
	if not fn then
		warn(("[Landing] UNRESOLVED/BELUM DIIMPLEMENTASI: handler '%s' (tile %d)"):format(info.type, tileIndex))
		return Result.CONTINUE
	end
	return fn(player, tileIndex, info, ctx) or Result.CONTINUE
end

-- Start: reward sudah dibayar StartService sebelum Landing. Landing Start Upgrade = fase Property.
LandingResolver.register("Start", function()
	return Result.CONTINUE
end)

return LandingResolver
