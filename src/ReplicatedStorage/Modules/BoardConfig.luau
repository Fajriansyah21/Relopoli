-- BoardConfig: layout papan Tile 0-39 (Master List, Progress #10 Daftar Property + #18 Crown)
-- Tile bertipe "News" (3, 13, 27, 37) ditentukan lewat eliminasi: tidak ada di daftar
-- Property/Crown/Start/Jail/Reward/Transport. Dokumen tidak menyebut posisinya secara eksplisit.
-- STATUS: PERLU KONFIRMASI DESAIN.

local BoardConfig = {}

local function P(name, district, set) return { type = "Property", name = name, district = district, set = set } end
local function C(name, district) return { type = "Crown", name = name, district = district } end

BoardConfig.Tiles = {
	[0]  = { type = "Start", name = "Start" },
	[1]  = P("Pinewood Lane", 1),
	[2]  = P("Maple Row", 1),
	[3]  = { type = "News", name = "Relopoli News" },
	[4]  = P("Willow Cafe", 1, 1),
	[5]  = P("Sunny Market", 1, 1),
	[6]  = P("Bloom Gardens", 1, 1),
	[7]  = C("The Verdant Crown", 1),
	[8]  = P("Riverside Walk", 1),
	[9]  = P("Harborview Hotel", 1),

	[10] = { type = "Jail", name = "Jail" },
	[11] = P("Metroline Offices", 2),
	[12] = P("Lantern Square", 2),
	[13] = { type = "News", name = "Relopoli News" },
	[14] = P("Grand Avenue", 2),
	[15] = P("Velvet Theater", 2),
	[16] = C("The Radiant Crown", 2),
	[17] = P("Central Brew", 2, 2),
	[18] = P("Civic Plaza", 2, 2),
	[19] = P("Skyline Suites", 2, 2),

	[20] = { type = "Reward", name = "Reward" },
	[21] = P("Pixel Plaza", 3, 3),
	[22] = P("Starfall Park", 3, 3),
	[23] = P("Starlight Arena", 3, 3),
	[24] = C("The Stellar Crown", 3),
	[25] = P("Neon Bowl", 3),
	[26] = P("AquaVista", 3),
	[27] = { type = "News", name = "Relopoli News" },
	[28] = P("Prism Cinema", 3),
	[29] = P("Grand Escape Resort", 3),

	[30] = { type = "Transport", name = "Transport" },
	[31] = P("Aurelia Maison", 4),
	[32] = P("Celestia Dining", 4),
	[33] = C("The Imperial Crown", 4),
	[34] = P("Opaline Gallery", 4, 4),
	[35] = P("Maison Royale", 4, 4),
	[36] = P("Lumina Jewel House", 4, 4),
	[37] = { type = "News", name = "Relopoli News" },
	[38] = P("Grand Meridian", 4),
	[39] = P("Celestial Heights", 4),
}

BoardConfig.Sets = {
	[1] = { 4, 5, 6 },
	[2] = { 17, 18, 19 },
	[3] = { 21, 22, 23 },
	[4] = { 34, 35, 36 },
}

BoardConfig.CrownTileByDistrict = { [1] = 7, [2] = 16, [3] = 24, [4] = 33 }

function BoardConfig.getTile(index)
	return BoardConfig.Tiles[index]
end

-- Baris model fisik: Baris(floor(i/10)+1) / Tile(i)
function BoardConfig.getTilePart(index)
	local board = workspace:FindFirstChild("Board1")
	local baris = board and board:FindFirstChild("Baris" .. (math.floor(index / 10) + 1))
	return baris and baris:FindFirstChild("Tile" .. index)
end

return BoardConfig
