-- CrownFlow (server-only): handler Landing untuk tile Crown.
-- Unowned -> Crown Purchase UI (Buy / Cancel) | Own -> Crown Reward | Owned by Other -> tidak terjadi apa-apa.
-- Purchase UI hanya muncul bila Balance cukup (Crown Purchase tidak dapat dilakukan bila Balance kurang).

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Constants = require(RS.Modules.Constants)
local BoardConfig = require(RS.Modules.BoardConfig)
local GameState = require(SSS.Core.GameState)
local Economy = require(SSS.Core.Economy)
local LandingResolver = require(SSS.Core.LandingResolver)
local CrownService = require(SSS.Core.CrownService)
local Liquidation = require(SSS.Core.Liquidation)
local PropertyFlow = require(SSS.Core.PropertyFlow)

local Result = Constants.Result

local CrownFlow = {}

local function send(name, player, payload)
	local remotes = RS:FindFirstChild("RemoteEvents")
	local re = remotes and remotes:FindFirstChild(name)
	if re and typeof(player) == "Instance" then re:FireClient(player, payload) end
end

local function landing(player, tile)
	local userId = player.UserId
	local owner = CrownService.getOwner(tile)

	if owner == nil then
		local price = CrownService.value(tile)
		if Economy.getBalance(userId) >= price then
			PropertyFlow.ask(player, "buy_crown", tile, { price = price })
		end
	elseif owner == userId then
		local ok, amount, detail = CrownService.claimReward(userId, tile)
		if ok then
			-- Reward Popup + Floating Reward (UI membaca payload ini)
			send("CrownReward", player, {
				tile = tile, name = BoardConfig.Tiles[tile].name, amount = amount,
				disrupted = detail.disrupted, prosperity = detail.prosperity,
			})
		end
	end
	-- Crown milik pemain lain: tidak ada Rent / Reward / Purchase / interaksi

	if not GameState.isRunning() then return Result.GAME_END end
	return Result.CONTINUE
end

local inited = false
function CrownFlow.init()
	if inited then return end
	inited = true
	CrownService.init()
	Liquidation.registerSource(CrownService.LiquidationSource)
	LandingResolver.register("Crown", landing)
	PropertyFlow.registerKind("buy_crown", function(player, p, data)
		if data.action ~= "buy" then return false, "INVALID_ACTION" end
		return CrownService.purchase(player.UserId, p.tile, { opId = "crown:" .. p.id })
	end)
end

return CrownFlow
