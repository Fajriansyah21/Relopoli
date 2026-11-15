-- Constants: nilai gameplay terpusat (Relopoli Master Source of Truth, Progress 1-20)
-- JANGAN tambah/ubah nilai di sini tanpa keputusan desain.

local Constants = {}

Constants.CURRENCY_UNIT = 500           -- semua nominal kelipatan 500 Rels
Constants.MAX_PLAYERS = 4
Constants.TILE_COUNT = 40               -- Tile 0..39
Constants.START_TILE = 0
Constants.JAIL_TILE = 10
Constants.REWARD_TILE = 20
Constants.TRANSPORT_TILE = 30

Constants.STARTING_CAPITAL = 250000
Constants.PASS_START = 20000
Constants.LANDING_START = 30000
Constants.FIRST_LAP_TOTAL = 100000      -- total, menggantikan bonus Start pada movement tsb
Constants.START_UPGRADE_DISCOUNT = 0.10 -- hidden, +-10%

Constants.JAIL_PAY = 25000
Constants.JAIL_FORCED_PAY = 50000
Constants.JAIL_MAX_ATTEMPTS = 5

Constants.SECOND_LIFE_BALANCE = 50000
Constants.PROPERTY_LIQUIDATION_RATE = 0.8
Constants.CROWN_LIQUIDATION_RATE = 1.0
Constants.SET_BONUS_MULTIPLIER = 1.2    -- nilai Set Rent aktual memakai tabel langsung

Constants.CROWN_REWARD_PER_PROPERTY = 20000 -- Progress 18 (menggantikan 1.000)
Constants.CROWN_REWARD_MAX = 140000
Constants.CROWN_PROSPERITY_BONUS = 2000
Constants.CROWN_VALUE_MULTIPLIER_TX = 3 -- minimum harga Transaction Crown
Constants.CROWN_VALUE = { D1 = 73500, D2 = 117500, D3 = 156000, D4 = 200000 }

Constants.MODIFIER_DURATION_ROUNDS = 3   -- per Round (crossing 39->0); Round saat modifier diperoleh tidak dihitung
Constants.PREMIUM_LISTING_MULTIPLIER = 1.5
Constants.FALLING_DEMAND_MULTIPLIER = 0.5
Constants.REWARD_MULTIPLIER = 2            -- belum ada L5 di room
Constants.REWARD_MULTIPLIER_WITH_L5 = 3    -- minimal 1 L5 di room
Constants.CROWN_COUNT = 4
Constants.SET_COUNT = 4

Constants.TRADE_MAX_ASSETS_PER_SIDE = 3
Constants.PROPOSAL_EXPIRY_SECONDS = 30 * 60
Constants.MAX_COUNTER_OFFERS = 1

Constants.DOUBLE_LIMIT = 3              -- Double ke-3 = Triple Double
Constants.MAX_STORED_NEWS_PER_TURN = 1

-- Fast Travel: {jarakMaks, biaya}
Constants.TRANSPORT_FEES = {
	{ 5, 5000 }, { 10, 7500 }, { 15, 10000 }, { 20, 12500 },
	{ 25, 15000 }, { 30, 17500 }, { 35, 20000 }, { 39, 22500 },
}

-- L5 Victory: jumlah Active Player -> target L5
Constants.L5_VICTORY_TARGET = { [4] = 18, [3] = 21, [2] = 23 }

Constants.PLAYER_COLORS = {
	[1] = { name = "Red",    color = Color3.fromRGB(220, 50, 50) },
	[2] = { name = "Blue",   color = Color3.fromRGB(50, 100, 220) },
	[3] = { name = "Green",  color = Color3.fromRGB(50, 180, 50) },
	[4] = { name = "Yellow", color = Color3.fromRGB(230, 200, 0) },
}

-- Enum
Constants.GameState = { RUNNING = "RUNNING", ENDED = "ENDED" }
Constants.PlayerState = { ACTIVE = "ACTIVE", ELIMINATED = "ELIMINATED", WINNER = "WINNER" }

-- Resolution Result + prioritas (angka lebih besar = menang)
Constants.Result = {
	CONTINUE = "CONTINUE",
	EXTRA_ROLL = "EXTRA_ROLL",
	TURN_END = "TURN_END",
	PLAYER_ELIMINATED = "PLAYER_ELIMINATED",
	GAME_END = "GAME_END",
}
Constants.ResultPriority = {
	CONTINUE = 1, EXTRA_ROLL = 2, TURN_END = 3, PLAYER_ELIMINATED = 4, GAME_END = 5,
}

-- Fase Turn
Constants.Phase = {
	IDLE = "IDLE",
	TURN_START = "TURN_START",
	NEWS_PHASE = "NEWS_PHASE",
	ROLL = "ROLL",
	DICE_RESOLUTION = "DICE_RESOLUTION",
	MOVEMENT = "MOVEMENT",
	START_CHECK = "START_CHECK",
	LANDING = "LANDING",
	SPECIAL_RESOLUTION = "SPECIAL_RESOLUTION",
	VICTORY_CHECK = "VICTORY_CHECK",
	EXTRA_ROLL_CHECK = "EXTRA_ROLL_CHECK",
	TURN_END = "TURN_END",
}

return table.freeze(Constants)
