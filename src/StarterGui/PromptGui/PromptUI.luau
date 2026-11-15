-- PromptGui (client): UI untuk prompt gameplay dari server.
--   PropertyPrompt : Buy Property / Upgrade / Buy dari pemilik (L1-L4) / Buy Crown / Reward Select
--   LiquidationPrompt : Asset Liquidation (pemain memilih aset sendiri)
--   CrownReward : popup Crown Reward ; Notify : pesan singkat
-- UI hanya REPRESENTASI. Semua tombol hanya mengirim INTENT; server memvalidasi dan menutup prompt.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local Remotes = RS:WaitForChild("RemoteEvents")
local PropertyPrompt = Remotes:WaitForChild("PropertyPrompt")
local PropertyAction = Remotes:WaitForChild("PropertyAction")
local PropertyPromptClosed = Remotes:WaitForChild("PropertyPromptClosed")
local LiquidationPrompt = Remotes:WaitForChild("LiquidationPrompt")
local LiquidationAction = Remotes:WaitForChild("LiquidationAction")
local LiquidationClosed = Remotes:WaitForChild("LiquidationClosed")
local CrownReward = Remotes:WaitForChild("CrownReward")
local Notify = Remotes:WaitForChild("Notify")

local gui = script.Parent

local C = {
	navy = Color3.fromRGB(14, 26, 54),
	navy2 = Color3.fromRGB(28, 46, 90),
	gold = Color3.fromRGB(232, 186, 40),
	text = Color3.fromRGB(240, 244, 255),
	dim = Color3.fromRGB(150, 162, 190),
	green = Color3.fromRGB(64, 160, 104),
	red = Color3.fromRGB(190, 66, 66),
	warn = Color3.fromRGB(240, 160, 60),
	off = Color3.fromRGB(70, 78, 100),
}

local REASONS = {
	INSUFFICIENT = "Rels tidak cukup.",
	UPGRADE_LIMIT = "Maksimal 1 upgrade per turn.",
	ALREADY_OWNED = "Sudah dimiliki.",
	NOT_OWNER = "Bukan milikmu.",
	INVALID_LEVEL = "Level tidak valid.",
	INVALID_PATH = "Upgrade tidak valid.",
	DUPLICATE = "Permintaan sudah diproses.",
	GAME_ENDED = "Game sudah berakhir.",
}

local function fmt(n)
	local s = tostring(math.floor(n or 0))
	local r = s:reverse():gsub("(%d%d%d)", "%1,")
	r = r:reverse()
	return (r:gsub("^,", ""))
end

local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	o.Parent = parent
	return o
end

local function round(o, r) make("UICorner", { CornerRadius = UDim.new(0, r or 10) }, o) end
local function outline(o, color, th) make("UIStroke", { Color = color, Thickness = th or 2 }, o) end

local function label(parent, text, size, color, bold)
	return make("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, size + 6),
		Text = text,
		TextColor3 = color or C.text,
		TextSize = size,
		Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
	}, parent)
end

local function button(parent, text, color, enabled, onClick, width)
	local b = make("TextButton", {
		Size = UDim2.fromOffset(width or 110, 34),
		BackgroundColor3 = enabled and color or C.off,
		AutoButtonColor = enabled,
		Active = enabled,
		Text = text,
		TextColor3 = enabled and C.text or C.dim,
		TextSize = 15,
		Font = Enum.Font.GothamBold,
	}, parent)
	round(b, 8)
	if enabled then
		b.Activated:Connect(function()
			b.Active = false -- UX anti double-click; validasi sebenarnya di server
			onClick()
			task.delay(0.6, function()
				if b.Parent then b.Active = true end
			end)
		end)
	end
	return b
end

-- Panel modal di tengah layar
local function newPanel(title, accent)
	local frame = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(480, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = C.navy,
	}, gui)
	round(frame, 14)
	outline(frame, accent or C.gold, 2)
	make("UIPadding", {
		PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16),
		PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18),
	}, frame)
	make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
	label(frame, title, 22, accent or C.gold, true)
	return frame
end

local function row(parent)
	local r = make("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = C.navy2 }, parent)
	round(r, 8)
	make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 8) }, r)
	return r
end

local function rowLayout(r)
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 10),
	}, r)
end

local function rowText(r, text, sub)
	local t = make("TextLabel", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -130, 1, 0), Position = UDim2.new(0, 0, 0, 0),
		Text = text .. (sub and ("\n" .. sub) or ""), TextColor3 = C.text, TextSize = 15, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, RichText = false,
	}, r)
	return t
end

-- ===== Property / Crown / Reward prompt =====
local current = nil -- { id, frame }

local function closePrompt(id)
	if current and (id == nil or current.id == id) then
		current.frame:Destroy()
		current = nil
	end
end

local function send(id, data)
	data.id = id
	PropertyAction:FireServer(data)
end

local function cancelRow(frame, id)
	local r = make("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1 }, frame)
	make("UIListLayout", { HorizontalAlignment = Enum.HorizontalAlignment.Right, FillDirection = Enum.FillDirection.Horizontal }, r)
	button(r, "Cancel", C.red, true, function() send(id, { action = "cancel" }) end)
end

local function showPrompt(p)
	closePrompt()
	local id, kind = p.id, p.kind
	local title, accent = p.name or "", C.gold
	local frame

	if kind == "buy_unowned" then
		frame = newPanel("Buy Property — " .. title)
		label(frame, ("District %s   •   Balance: %s Rels"):format(tostring(p.district or "?"), fmt(p.balance)), 14, C.dim)
		for _, o in ipairs(p.options or {}) do
			local r = row(frame)
			rowText(r, ("L%d"):format(o.level), fmt(o.price) .. " Rels")
			rowLayout(r)
			button(r, "Buy L" .. o.level, C.green, o.enabled, function() send(id, { action = "buy", level = o.level }) end)
		end
		for lv = 4, 5 do -- L4/L5 tidak bisa dibeli langsung
			local r = row(frame)
			rowText(r, ("L%d"):format(lv), "Tidak tersedia untuk pembelian awal")
			rowLayout(r)
			button(r, "Locked", C.off, false, function() end)
		end
		cancelRow(frame, id)

	elseif kind == "upgrade" then
		frame = newPanel("Upgrade — " .. title)
		label(frame, ("Level sekarang: L%d   •   Balance: %s Rels"):format(p.currentLevel or 1, fmt(p.balance)), 14, C.dim)
		for _, o in ipairs(p.options or {}) do
			local r = row(frame)
			rowText(r, ("Upgrade ke L%d"):format(o.level), fmt(o.price) .. " Rels")
			rowLayout(r)
			button(r, "Upgrade", C.green, o.enabled, function() send(id, { action = "upgrade", level = o.level }) end)
		end
		cancelRow(frame, id)

	elseif kind == "buy_other" then
		frame = newPanel("Buy Property — " .. title)
		label(frame, ("Rent sudah dibayar. Level L%d   •   Balance: %s Rels"):format(p.currentLevel or 1, fmt(p.balance)), 14, C.dim)
		local r = row(frame)
		rowText(r, "Harga (Property Value)", fmt(p.price) .. " Rels")
		rowLayout(r)
		button(r, "Buy", C.green, (p.balance or 0) >= (p.price or math.huge), function() send(id, { action = "buy" }) end)
		cancelRow(frame, id)

	elseif kind == "buy_crown" then
		frame = newPanel("Buy Crown — " .. title)
		label(frame, ("District %s   •   Balance: %s Rels"):format(tostring(p.district or "?"), fmt(p.balance)), 14, C.dim)
		local r = row(frame)
		rowText(r, "Crown Value", fmt(p.price) .. " Rels")
		rowLayout(r)
		button(r, "Buy", C.green, (p.balance or 0) >= (p.price or math.huge), function() send(id, { action = "buy" }) end)
		cancelRow(frame, id)

	elseif kind == "reward_select" then
		frame = newPanel(("Reward x%s — pilih 1 Property"):format(tostring(p.multiplier or 2)))
		label(frame, "Rent Property yang dipilih dikali selama 3 Round.", 14, C.dim)
		local list = make("ScrollingFrame", {
			Size = UDim2.new(1, 0, 0, math.min(#(p.options or {}), 6) * 52),
			BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6,
			CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		}, frame)
		make("UIListLayout", { Padding = UDim.new(0, 8) }, list)
		for _, o in ipairs(p.options or {}) do
			local r = row(list)
			rowText(r, o.name, ("L%d"):format(o.level))
			rowLayout(r)
			button(r, "Select", C.green, true, function() send(id, { action = "select", tile = o.tile }) end)
		end
		-- Reward wajib dipilih: tidak ada Cancel
	else
		return
	end

	current = { id = id, frame = frame }
end

PropertyPrompt.OnClientEvent:Connect(function(p)
	if typeof(p) == "table" then showPrompt(p) end
end)
PropertyPromptClosed.OnClientEvent:Connect(function(d)
	if typeof(d) == "table" then closePrompt(d.id) end
end)

-- ===== Asset Liquidation =====
local liq = nil
local function closeLiquidation()
	if liq then liq:Destroy() liq = nil end
end

LiquidationPrompt.OnClientEvent:Connect(function(d)
	closeLiquidation()
	if typeof(d) ~= "table" then return end
	local frame = newPanel("Asset Liquidation", C.red)
	label(frame, ("Saldo negatif. Pilih aset yang dijual.   Balance: %s Rels"):format(fmt(player:GetAttribute("Rels") or 0)), 14, C.dim)
	local list = make("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, math.min(#(d.assets or {}), 6) * 74),
		BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6,
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, frame)
	make("UIListLayout", { Padding = UDim.new(0, 8) }, list)
	for _, a in ipairs(d.assets or {}) do
		local r = row(list)
		r.Size = UDim2.new(1, 0, 0, a.setBreak and 66 or 44)
		rowText(r, a.label, ("%s   •   +%s Rels%s"):format(a.kind, fmt(a.value),
			a.setBreak and "\nProperty ini bagian dari Set. Menjualnya akan memutus Set." or ""))
		rowLayout(r)
		button(r, "Sell", C.red, true, function() LiquidationAction:FireServer(a.kind, a.id) end, 90)
	end
	liq = frame
end)
LiquidationClosed.OnClientEvent:Connect(closeLiquidation)

-- ===== Toast: Crown Reward / Notify =====
local function toast(text, color, big)
	local t = make("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, big and 70 or 24),
		Size = UDim2.fromOffset(big and 460 or 380, big and 70 or 40),
		BackgroundColor3 = C.navy, BackgroundTransparency = 0.1,
		Text = text, TextColor3 = color or C.text, TextSize = big and 26 or 16, Font = Enum.Font.GothamBold,
		TextWrapped = true,
	}, gui)
	round(t, 12)
	outline(t, color or C.gold, 2)
	task.delay(big and 3 or 2.2, function()
		local tw = TweenService:Create(t, TweenInfo.new(0.4), { TextTransparency = 1, BackgroundTransparency = 1 })
		tw:Play()
		tw.Completed:Wait()
		t:Destroy()
	end)
end

CrownReward.OnClientEvent:Connect(function(d)
	if typeof(d) ~= "table" then return end
	if d.amount and d.amount > 0 then
		toast(("%s\n+%s Rels"):format(d.name or "Crown", fmt(d.amount)), C.gold, true)
	else
		toast(("%s\nCrown Disrupted: Reward 0 Rels"):format(d.name or "Crown"), C.warn, true)
	end
end)

Notify.OnClientEvent:Connect(function(d)
	if typeof(d) ~= "table" or typeof(d.text) ~= "string" then return end
	toast(REASONS[d.text] or d.text, C.warn, false)
end)
