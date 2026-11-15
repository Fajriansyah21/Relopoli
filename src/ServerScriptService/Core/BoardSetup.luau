-- BoardSetup (server-only): menyelaraskan data tile fisik dengan BoardConfig (Master List).
-- BoardConfig = satu-satunya sumber tipe/nama tile. Artwork (Decal) tile TIDAK diubah di sini.

local RS = game:GetService("ReplicatedStorage")

local BoardConfig = require(RS.Modules.BoardConfig)
local Constants = require(RS.Modules.Constants)

local BoardSetup = {}

local function stringValue(parent, name, value)
	local v = parent:FindFirstChild(name)
	if not v then
		v = Instance.new("StringValue")
		v.Name = name
		v.Parent = parent
	end
	v.Value = value
end

function BoardSetup.apply()
	local applied = 0
	for i = 0, Constants.TILE_COUNT - 1 do
		local info = BoardConfig.getTile(i)
		local part = BoardConfig.getTilePart(i)
		if info and part then
			stringValue(part, "TileType", info.type)
			stringValue(part, "TileName", info.name)
			part:SetAttribute("TileIndex", i)
			part:SetAttribute("TileType", info.type)
			part:SetAttribute("TileName", info.name)
			part:SetAttribute("District", info.district)
			part:SetAttribute("SetId", info.set)
			applied += 1
		else
			warn(("[BoardSetup] Tile %d tidak lengkap (config/part hilang)"):format(i))
		end
	end
	print(("[BoardSetup] %d/%d tile diselaraskan dengan BoardConfig"):format(applied, Constants.TILE_COUNT))
	return applied
end

return BoardSetup
