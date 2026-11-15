-- DiceBridge: penghubung antara RollFlow (logika giliran) dan DiceSystem (dadu fisik lama).
-- Client TIDAK pernah memicu dadu langsung; hanya server (lewat Turn Controller) yang memanggil request().

local DiceBridge = {}

local requested = Instance.new("BindableEvent")
local rolled = Instance.new("BindableEvent")

DiceBridge.RollRequested = requested.Event -- (player)
DiceBridge.Rolled = rolled.Event           -- (player, die1, die2) hanya hasil VALID

function DiceBridge.request(player)
	requested:Fire(player)
end

function DiceBridge.deliver(player, die1, die2)
	rolled:Fire(player, die1, die2)
end

return DiceBridge
