-- PlayerScreen (client): Player Identity + Player Actions + Feature Panel + Assets Panel.
--   Identity (kiri bawah): avatar, nama Roblox, Rels. Dapat Hide/Show.
--   Utility (kanan atas): [Shop] [Settings] [Menu]. Menu membuka Action Dock: News, Trade, Transaction, Assets.
--   Feature Panel di tengah layar, hanya satu aktif, board di-blur ringan.
--   Assets Panel = Information Hub (Properties / Crowns, List + Detail). View on Board = Outline + Floating Arrow.
-- UI hanya REPRESENTASI state dari server. Tidak ada aturan gameplay di sini.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local Modules = RS:WaitForChild("Modules")
local Constants = require(Modules:WaitForChild("Constants"))
local BoardConfig = require(Modules:WaitForChild("BoardConfig"))
local ArrowIndicator = require(Modules:WaitForChild("ArrowIndicator"))
local Remotes = RS:WaitForChild("RemoteEvents")
local TurnChanged = Remotes:WaitForChild("TurnChanged")
local RequestSync = Remotes:WaitForChild("RequestSync")
local GetAssets = Remotes:WaitForChild("GetAssets")
local AssetsChanged = Remotes:WaitForChild("AssetsChanged")

local Phase = Constants.Phase
local gui = script.Parent

local VIEW_DURATION = 6 -- detik (Extended Fixed Duration untuk Outline + Arrow)

local C = {
	navy = Color3.fromRGB(14, 26, 54),
	navy2 = Color3.fromRGB(28, 46, 90),
	navy3 = Color3.fromRGB(42, 66, 120),
	gold = Color3.fromRGB(232, 186, 40),
	text = Color3.fromRGB(240, 244, 255),
	dim = Color3.fromRGB(150, 162, 190),
	green = Color3.fromRGB(64, 160, 104),
	red = Color3.fromRGB(190, 66, 66),
	warn = Color3.fromRGB(240, 160, 60),
	off = Color3.fromRGB(70, 78, 100),
}
-- Palet UI sementara untuk identitas District (bukan aturan gameplay)
local DISTRICT_COLOR = {
	[1] = Color3.fromRGB(70, 160, 96), [2] = Color3.fromRGB(226, 140, 50),
	[3] = Color3.fromRGB(150, 90, 210), [4] = Color3.fromRGB(214, 176, 46),
}

-- ===== helper =====
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
local function outline(o, color, th) return make("UIStroke", { Color = color, Thickness = th or 2 }, o) end
local function pad(o, t, b, l, r)
	make("UIPadding", { PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b), PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r) }, o)
end
local function vlist(o, gap) return make("UIListLayout", { Padding = UDim.new(0, gap or 8), SortOrder = Enum.SortOrder.LayoutOrder }, o) end
local function clear(o)
	for _, c in ipairs(o:GetChildren()) do
		if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
	end
end

local function text(parent, str, size, color, bold, props)
	local p = {
		BackgroundTransparency = 1, Text = str, TextColor3 = color or C.text, TextSize = size,
		Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true, Size = UDim2.new(1, 0, 0, size + 6),
	}
	if props then for k, v in pairs(props) do p[k] = v end end
	return make("TextLabel", p, parent)
end

local function styleButton(b, enabled, color)
	b.BackgroundColor3 = enabled and color or C.off
	b.TextColor3 = enabled and C.text or C.dim
	b.AutoButtonColor = enabled
	b.Active = enabled
end

local function slotColor(slot)
	local c = Constants.PLAYER_COLORS[slot or 1]
	return c and c.color or C.gold
end

-- ===== state umum =====
local currentPanel = nil     -- { name, frame }
local assetsState = { tab = "Properties", selected = {} } -- bertahan selama Assets belum ditutup dengan X
local assetsData = nil
local locked = false          -- proses otomatis milik pemain ini (Roll/Movement/Landing/...)
local dockButtons = {}
local restorePill = nil
local viewHandle = nil

local blur = make("BlurEffect", { Size = 0 }, Lighting)
local function setBlur(on)
	TweenService:Create(blur, TweenInfo.new(0.2), { Size = on and 10 or 0 }):Play()
end

local openPanel -- forward

-- ===== View on Board (Outline + Floating Arrow, shared Arrow system) =====
local function clearView()
	if viewHandle then
		ArrowIndicator.clear(viewHandle.arrow)
		if viewHandle.highlight then viewHandle.highlight:Destroy() end
		viewHandle = nil
	end
end

local function closePanel(resetState)
	if currentPanel then
		currentPanel.frame:Destroy()
		currentPanel = nil
		setBlur(false)
	end
	if restorePill then restorePill:Destroy() restorePill = nil end
	if resetState then
		assetsState = { tab = "Properties", selected = {} }
		assetsData = nil
	end
end

local function minimizeAssets()
	closePanel(false) -- state Assets tetap tersimpan (masih dianggap terbuka)
	restorePill = make("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 18), Size = UDim2.fromOffset(190, 34),
		BackgroundColor3 = C.navy, TextColor3 = C.gold, TextSize = 14, Font = Enum.Font.GothamBold,
		Text = "Restore Assets Panel",
	}, gui)
	round(restorePill, 17)
	outline(restorePill, C.gold, 2)
	restorePill.Activated:Connect(function() openPanel("Assets") end)
end

local function viewOnBoard(tile)
	clearView()
	minimizeAssets()
	local part = BoardConfig.getTilePart(tile)
	if not part then return end
	local hl = make("Highlight", {
		FillTransparency = 1, OutlineColor = C.gold, OutlineTransparency = 0,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Adornee = part,
	}, part)
	local token = {}
	viewHandle = { arrow = ArrowIndicator.show(tile, C.gold), highlight = hl, token = token }
	task.delay(VIEW_DURATION, function()
		if viewHandle and viewHandle.token == token then clearView() end
	end)
end

-- ===== Feature Panel host =====
local function newPanelFrame(name, title, width, height)
	local frame = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(width, height), BackgroundColor3 = C.navy,
	}, gui)
	round(frame, 14)
	outline(frame, C.gold, 2)
	local head = make("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1 }, frame)
	text(head, title, 22, C.gold, true, { Position = UDim2.new(0, 18, 0, 8), Size = UDim2.new(1, -70, 0, 30) })
	local x = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 8), Size = UDim2.fromOffset(32, 30),
		BackgroundColor3 = C.red, Text = "X", TextColor3 = C.text, TextSize = 16, Font = Enum.Font.GothamBold,
	}, head)
	round(x, 8)
	x.Activated:Connect(function() closePanel(true) end) -- X hanya menutup panel
	return frame
end

-- ===== Assets Panel =====
local function statusLines(mods)
	local out = {}
	for _, m in ipairs(mods or {}) do
		local k = m.kind
		if k == "PremiumListing" then table.insert(out, ("Premium Listing x1.5 (%d Round)"):format(m.roundsLeft or 0))
		elseif k == "FallingDemand" then table.insert(out, ("Falling Demand x0.5 (%d Round)"):format(m.roundsLeft or 0))
		elseif k == "HalfRent" then table.insert(out, ("Half Rent - holder %s (%d Round)"):format(m.holderName or "?", m.roundsLeft or 0))
		elseif k == "Slump" then table.insert(out, "Inactive (Property Slump) - Rent 0")
		elseif k == "Reward" then table.insert(out, ("Reward x%s (%d Round)"):format(tostring(m.multiplier or 2), m.roundsLeft or 0))
		elseif k == "Prosperity" then table.insert(out, ("Crown Prosperity +2,000 (%d Round)"):format(m.roundsLeft or 0))
		elseif k == "Disruption" then table.insert(out, "Crown Disrupted - Reward berikutnya 0")
		else table.insert(out, tostring(k)) end
	end
	if #out == 0 then out[1] = "Normal" end
	return out
end

local function kv(parent, k, v, vcolor)
	local r = make("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1 }, parent)
	text(r, k, 15, C.dim, false, { Size = UDim2.new(0.5, 0, 1, 0) })
	text(r, v, 15, vcolor or C.text, true, { Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.fromScale(0.5, 0), TextXAlignment = Enum.TextXAlignment.Right })
	return r
end

-- Artwork aktual dari ReplicatedStorage.Bangunan3D (L1-L4). Model lain (L5, Crown) = placeholder sampai tersedia.
local function artwork(parent, modelName, placeholderText)
	local holder = make("Frame", { Size = UDim2.new(1, 0, 0, 170), BackgroundColor3 = C.navy2 }, parent)
	round(holder, 10)
	local folder = RS:FindFirstChild("Bangunan3D")
	local src = folder and folder:FindFirstChild(modelName)
	if not src or not src:IsA("Model") then
		text(holder, placeholderText, 14, C.dim, false, {
			Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
		})
		return holder
	end
	local vf = make("ViewportFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, holder)
	local model = src:Clone()
	model.Parent = vf
	local cam = make("Camera", { FieldOfView = 40 }, vf)
	vf.CurrentCamera = cam
	local cf, size = model:GetBoundingBox()
	local radius = math.max(size.Magnitude / 2, 1)
	local dist = radius / math.tan(math.rad(cam.FieldOfView / 2))
	cam.CFrame = CFrame.new(cf.Position + Vector3.new(1, 0.7, 1).Unit * dist * 1.05, cf.Position)
	return holder
end

local function actionButtons(detail, tile)
	local primary = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = C.green, Text = "View on Board",
		TextColor3 = C.text, TextSize = 16, Font = Enum.Font.GothamBold,
	}, detail)
	round(primary, 8)
	primary.Activated:Connect(function() viewOnBoard(tile) end)

	local row = make("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1 }, detail)
	make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 12) }, row)
	for _, n in ipairs({ "Trade", "Transaction" }) do
		local b = make("TextButton", { Size = UDim2.fromOffset(150, 34), Text = n, TextSize = 15, Font = Enum.Font.GothamBold }, row)
		round(b, 8)
		styleButton(b, false, C.navy3) -- sistem Trade/Transaction belum dibuat
	end
	text(detail, "Trade / Transaction belum tersedia", 12, C.dim, false, { TextXAlignment = Enum.TextXAlignment.Center })
end

local function ownershipBlock(detail, data)
	text(detail, "Ownership", 14, C.dim, false)
	local r = make("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, detail)
	local bar = make("Frame", { Size = UDim2.fromOffset(5, 26), Position = UDim2.fromOffset(0, 2), BackgroundColor3 = slotColor(data.slot), BorderSizePixel = 0 }, r)
	round(bar, 3)
	text(r, data.name or "?", 16, C.text, true, { Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -14, 1, 0) })
end

local function renderPropertyDetail(detail, p, data)
	local head = make("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1 }, detail)
	local bar = make("Frame", { Size = UDim2.fromOffset(5, 46), Position = UDim2.fromOffset(0, 3), BackgroundColor3 = slotColor(data.slot), BorderSizePixel = 0 }, head)
	round(bar, 3)
	text(head, p.name, 22, C.text, true, { Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -90, 0, 28) })
	text(head, ("District %s"):format(tostring(p.district)), 14, C.dim, false, { Position = UDim2.fromOffset(14, 28), Size = UDim2.new(1, -90, 0, 20) })
	local badge = make("TextLabel", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 4), Size = UDim2.fromOffset(60, 26),
		BackgroundColor3 = DISTRICT_COLOR[p.district] or C.off, Text = "Lv." .. p.level, TextColor3 = C.text, TextSize = 15, Font = Enum.Font.GothamBold,
	}, head)
	round(badge, 8)

	artwork(detail, "L" .. p.level, ("Model L%d belum tersedia"):format(p.level))
	kv(detail, "Property Value", fmt(p.value) .. " Rels")
	kv(detail, "Rent", fmt(p.rent) .. " Rels")

	if p.set then
		local s = p.set
		kv(detail, ("SET #%d"):format(s.id), ("%d / %d"):format(s.owned, s.total), s.complete and C.gold or C.text)
		for _, m in ipairs(s.members) do
			text(detail, (m.owned and "✓  " or "○  ") .. m.name, 14, m.owned and C.text or C.dim, false)
		end
	end
	local lines = statusLines(p.modifiers)
	kv(detail, "Status", lines[1], lines[1] == "Normal" and C.text or C.warn)
	for i = 2, #lines do text(detail, lines[i], 14, C.warn, false, { TextXAlignment = Enum.TextXAlignment.Right }) end

	ownershipBlock(detail, data)
	actionButtons(detail, p.tile)
end

local function renderCrownDetail(detail, c, data)
	local head = make("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1 }, detail)
	local bar = make("Frame", { Size = UDim2.fromOffset(5, 46), Position = UDim2.fromOffset(0, 3), BackgroundColor3 = slotColor(data.slot), BorderSizePixel = 0 }, head)
	round(bar, 3)
	text(head, c.name, 22, C.gold, true, { Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -20, 0, 28) })
	text(head, ("District %s"):format(tostring(c.district)), 14, C.dim, false, { Position = UDim2.fromOffset(14, 28), Size = UDim2.new(1, -20, 0, 20) })

	local holder = artwork(detail, "Crown_" .. tostring(c.district), "Model Crown belum tersedia")
	outline(holder, C.gold, 1)
	kv(detail, "Crown Value", fmt(c.value) .. " Rels")
	local lines = statusLines(c.modifiers)
	kv(detail, "Status", lines[1], lines[1] == "Normal" and C.text or C.warn)
	for i = 2, #lines do text(detail, lines[i], 14, C.warn, false, { TextXAlignment = Enum.TextXAlignment.Right }) end
	ownershipBlock(detail, data)
	actionButtons(detail, c.tile)
end

local function buildAssets()
	local frame = newPanelFrame("Assets", "ASSETS", 880, 540)

	-- Tab tetap (Fixed)
	local tabs = make("Frame", { Position = UDim2.fromOffset(18, 46), Size = UDim2.new(1, -36, 0, 36), BackgroundTransparency = 1 }, frame)
	make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10) }, tabs)
	local tabButtons = {}
	local listFrame = make("ScrollingFrame", {
		Position = UDim2.fromOffset(18, 90), Size = UDim2.new(0, 330, 1, -108), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 6, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, frame)
	vlist(listFrame, 8)
	local detail = make("ScrollingFrame", {
		Position = UDim2.fromOffset(362, 90), Size = UDim2.new(1, -380, 1, -108), BackgroundColor3 = C.navy2, BackgroundTransparency = 0.4,
		BorderSizePixel = 0, ScrollBarThickness = 6, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, frame)
	round(detail, 10)
	pad(detail, 12, 12, 14, 14)
	vlist(detail, 8)

	local render

	local function card(parent, item, isCrown, selected)
		local h = isCrown and 96 or 84
		local b = make("TextButton", {
			Size = UDim2.new(1, -8, 0, h), BackgroundColor3 = selected and C.navy3 or C.navy2, AutoButtonColor = false, Text = "",
		}, parent)
		round(b, 10)
		if selected then outline(b, C.gold, 2) elseif isCrown then outline(b, C.gold, 1) end
		local acc = make("Frame", { Size = UDim2.new(0, 5, 1, -14), Position = UDim2.fromOffset(6, 7), BackgroundColor3 = slotColor(assetsData and assetsData.slot), BorderSizePixel = 0 }, b)
		round(acc, 3)
		-- glyph ringan (tanpa ViewportFrame per kartu agar tidak berat); artwork aktual ada di Detail
		local g = make("Frame", { Size = UDim2.fromOffset(isCrown and 70 or 60, isCrown and 70 or 60), Position = UDim2.new(0, 20, 0.5, isCrown and -35 or -30), BackgroundColor3 = isCrown and C.gold or (DISTRICT_COLOR[item.district] or C.off) }, b)
		round(g, 8)
		text(g, isCrown and "CROWN" or ("L" .. item.level), isCrown and 12 or 22, isCrown and C.navy or C.text, true, {
			Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
		})
		local x = isCrown and 102 or 92
		text(b, item.name, 16, isCrown and C.gold or C.text, true, { Position = UDim2.fromOffset(x, 10), Size = UDim2.new(1, -(x + 70), 0, 22) })
		text(b, ("District %s"):format(tostring(item.district)), 13, C.dim, false, { Position = UDim2.fromOffset(x, 34), Size = UDim2.new(1, -(x + 10), 0, 18) })
		if isCrown then
			text(b, ("Crown Value  %s Rels"):format(fmt(item.value)), 13, C.text, false, { Position = UDim2.fromOffset(x, 56), Size = UDim2.new(1, -(x + 10), 0, 18) })
		else
			if item.set then text(b, ("Set #%d"):format(item.set.id), 13, C.dim, false, { Position = UDim2.fromOffset(x, 54), Size = UDim2.new(1, -(x + 10), 0, 18) }) end
			local lv = make("TextLabel", {
				AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 10), Size = UDim2.fromOffset(46, 22),
				BackgroundColor3 = C.navy, Text = "Lv." .. item.level, TextColor3 = C.text, TextSize = 13, Font = Enum.Font.GothamBold,
			}, b)
			round(lv, 6)
			if #(item.modifiers or {}) > 0 then
				make("TextLabel", {
					AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -12, 1, -8), Size = UDim2.fromOffset(20, 20),
					BackgroundTransparency = 1, Text = "◆", TextColor3 = C.gold, TextSize = 16, Font = Enum.Font.GothamBold,
				}, b)
			end
		end
		b.MouseEnter:Connect(function() if not selected then b.BackgroundColor3 = C.navy3 end end)
		b.MouseLeave:Connect(function() if not selected then b.BackgroundColor3 = C.navy2 end end)
		b.Activated:Connect(function()
			assetsState.selected[assetsState.tab] = item.tile
			render()
		end)
		return b
	end

	local function styleTabs()
		for name, tb in pairs(tabButtons) do
			local active = assetsState.tab == name
			tb.BackgroundColor3 = active and C.gold or C.navy2
			tb.TextColor3 = active and C.navy or C.text
		end
	end

	function render()
		clear(listFrame)
		clear(detail)
		styleTabs()
		local isCrown = assetsState.tab == "Crowns"
		local items = {}
		if assetsData then items = isCrown and assetsData.crowns or assetsData.properties end
		if #items == 0 then
			text(listFrame, isCrown and "No Crowns Owned" or "No Properties Owned", 16, C.dim, false, { Size = UDim2.new(1, 0, 0, 40) })
			return
		end
		-- auto-select aset pertama bila belum ada pilihan / pilihan sudah tidak dimiliki
		local sel = assetsState.selected[assetsState.tab]
		local found
		for _, it in ipairs(items) do if it.tile == sel then found = it end end
		if not found then found = items[1]; assetsState.selected[assetsState.tab] = found.tile end
		for _, it in ipairs(items) do card(listFrame, it, isCrown, it == found) end
		if isCrown then renderCrownDetail(detail, found, assetsData) else renderPropertyDetail(detail, found, assetsData) end
	end

	for _, name in ipairs({ "Properties", "Crowns" }) do
		local tb = make("TextButton", {
			Size = UDim2.fromOffset(150, 34), Text = string.upper(name), TextSize = 15, Font = Enum.Font.GothamBold,
		}, tabs)
		round(tb, 8)
		tabButtons[name] = tb
		tb.Activated:Connect(function() assetsState.tab = name; render() end)
	end

	render() -- tampil dulu (empty state), lalu isi dari server
	task.spawn(function()
		local ok, res = pcall(function() return GetAssets:InvokeServer() end)
		if ok and typeof(res) == "table" then assetsData = res end
		if frame.Parent then render() end
	end)

	return frame, function() -- refresh dari server (real-time)
		local ok, res = pcall(function() return GetAssets:InvokeServer() end)
		if ok and typeof(res) == "table" then assetsData = res end
		if frame.Parent then render() end
	end
end

-- ===== Panel lain (placeholder sampai sistemnya dibuat) =====
local function buildSimple(name, title, body)
	local frame = newPanelFrame(name, title, 420, 220)
	text(frame, body, 18, C.dim, false, {
		Position = UDim2.fromOffset(18, 70), Size = UDim2.new(1, -36, 0, 80),
		TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
	})
	return frame
end

local refreshAssets = nil
function openPanel(name)
	closePanel(name ~= "Assets") -- pindah ke fitur lain: state Assets dibersihkan; sesama Assets (restore) dipertahankan
	clearView()
	refreshAssets = nil
	local frame
	if name == "Assets" then
		frame, refreshAssets = buildAssets()
	elseif name == "News" then
		frame = buildSimple("News", "NEWS", "No Stored News")
	elseif name == "Settings" then
		frame = buildSimple("Settings", "SETTINGS", "Settings akan tersedia di tahap berikutnya.")
	elseif name == "Shop" then
		frame = buildSimple("Shop", "SHOP", "Shop (Robux) akan tersedia di tahap berikutnya.")
	else
		return
	end
	currentPanel = { name = name, frame = frame }
	setBlur(true)
end

-- ===== Player Identity (kiri bawah) =====
local identity = make("Frame", {
	AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 16, 1, -16), Size = UDim2.fromOffset(300, 76), BackgroundTransparency = 1,
}, gui)
local idPanel = make("Frame", { Size = UDim2.fromOffset(270, 76), BackgroundColor3 = C.navy }, identity)
round(idPanel, 12)
outline(idPanel, C.gold, 2)
local avatar = make("ImageLabel", { Position = UDim2.fromOffset(10, 8), Size = UDim2.fromOffset(60, 60), BackgroundColor3 = C.navy2, Image = "" }, idPanel)
round(avatar, 30)
task.spawn(function()
	local ok, img = pcall(function()
		return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	end)
	if ok and avatar.Parent then avatar.Image = img end
end)
text(idPanel, player.Name, 17, C.text, true, { Position = UDim2.fromOffset(82, 12), Size = UDim2.new(1, -92, 0, 22), TextTruncate = Enum.TextTruncate.AtEnd })
local relsLabel = text(idPanel, "", 17, C.gold, true, { Position = UDim2.fromOffset(82, 40), Size = UDim2.new(1, -92, 0, 22) })
local function updateRels()
	relsLabel.Text = fmt(player:GetAttribute("Rels") or 0) .. " Rels"
end
updateRels()
player:GetAttributeChangedSignal("Rels"):Connect(updateRels)

local idTab = make("TextButton", {
	Position = UDim2.fromOffset(272, 18), Size = UDim2.fromOffset(26, 40), BackgroundColor3 = C.navy, Text = "<",
	TextColor3 = C.gold, TextSize = 18, Font = Enum.Font.GothamBold,
}, identity)
round(idTab, 8)
outline(idTab, C.gold, 2)
local idHidden = false
idTab.Activated:Connect(function()
	idHidden = not idHidden
	idTab.Text = idHidden and ">" or "<"
	TweenService:Create(identity, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
		Position = idHidden and UDim2.new(0, 16 - 272, 1, -16) or UDim2.new(0, 16, 1, -16),
	}):Play()
end)

-- ===== Utility (kanan atas): Shop, Settings, Menu =====
local util = make("Frame", {
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 16), Size = UDim2.fromOffset(330, 38), BackgroundTransparency = 1,
}, gui)
make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8) }, util)

local function utilButton(label, width, layoutOrder)
	local b = make("TextButton", {
		Size = UDim2.fromOffset(width, 36), BackgroundColor3 = C.navy, Text = label, TextColor3 = C.text, TextSize = 15,
		Font = Enum.Font.GothamBold, LayoutOrder = layoutOrder,
	}, util)
	round(b, 10)
	outline(b, C.gold, 2)
	return b
end
local shopBtn = utilButton("Shop", 90, 1)
local settingsBtn = utilButton("Settings", 110, 2)
local menuBtn = utilButton("Menu", 90, 3)
shopBtn.Activated:Connect(function() openPanel("Shop") end)
settingsBtn.Activated:Connect(function() openPanel("Settings") end)

-- ===== Action Dock =====
local DOCK_H = 4 * 46 + 3 * 6 + 16
local dock = make("Frame", {
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 60), Size = UDim2.fromOffset(200, 0),
	BackgroundColor3 = C.navy, ClipsDescendants = true, Visible = false,
}, gui)
round(dock, 12)
outline(dock, C.gold, 2)
pad(dock, 8, 8, 8, 8)
make("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, dock)

local dockOpen = false
local function setDock(open)
	dockOpen = open
	menuBtn.Text = open and "Close" or "Menu"
	if open then
		dock.Visible = true
		TweenService:Create(dock, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(200, DOCK_H) }):Play()
	else
		local tw = TweenService:Create(dock, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.fromOffset(200, 0) })
		tw:Play()
		tw.Completed:Connect(function() if not dockOpen then dock.Visible = false end end)
	end
end
menuBtn.Activated:Connect(function() setDock(not dockOpen) end)

local function refreshDock()
	for _, d in pairs(dockButtons) do
		local on = d.available and not locked
		styleButton(d.button, on, C.navy2)
		d.button.Text = (d.available and d.label) or (d.label .. '<br/><font size="11">belum tersedia</font>')
	end
end

local function dockButton(key, label, order, available, onClick)
	local b = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 46), Text = label, TextSize = 16, Font = Enum.Font.GothamBold,
		RichText = true, LayoutOrder = order, TextXAlignment = Enum.TextXAlignment.Left,
	}, dock)
	round(b, 8)
	pad(b, 0, 0, 14, 0)
	b.Activated:Connect(function()
		if locked or not available then return end
		setDock(false) -- Action Dock otomatis collapse; Menu tetap tersedia
		onClick()
	end)
	dockButtons[key] = { button = b, label = label, available = available }
end
dockButton("News", "📰  News", 1, true, function() openPanel("News") end)
dockButton("Trade", "⇄  Trade", 2, false, function() end)               -- sistem Trade belum dibuat
dockButton("Transaction", "💰  Transaction", 3, false, function() end)  -- sistem Transaction belum dibuat
dockButton("Assets", "🏠  Assets", 4, true, function() openPanel("Assets") end)
refreshDock()

-- ===== Sinkron dengan server =====
-- Player Screen tidak dapat dipakai saat proses otomatis milik pemain ini (Roll, Movement, Landing, ...).
local AUTOMATIC = {
	[Phase.ROLL] = true, [Phase.DICE_RESOLUTION] = true, [Phase.MOVEMENT] = true, [Phase.START_CHECK] = true,
	[Phase.LANDING] = true, [Phase.SPECIAL_RESOLUTION] = true, [Phase.VICTORY_CHECK] = true, [Phase.TURN_END] = true,
}
TurnChanged.OnClientEvent:Connect(function(state)
	if typeof(state) ~= "table" then return end
	locked = state.userId == player.UserId and AUTOMATIC[state.phase] == true
	refreshDock()
	if locked then
		setDock(false)
		closePanel(false)
		clearView()
	end
end)

local refreshQueued = false
AssetsChanged.OnClientEvent:Connect(function()
	if refreshQueued or not refreshAssets or not (currentPanel and currentPanel.name == "Assets") then return end
	refreshQueued = true
	task.delay(0.1, function()
		refreshQueued = false
		if refreshAssets and currentPanel and currentPanel.name == "Assets" then refreshAssets() end
	end)
end)

RequestSync:FireServer()

-- Hook uji (hanya aktif saat script diuji dengan tabel pengganti `script`; tidak ada di runtime Roblox)
if typeof(script) == "table" and script.__test then
	script.__test.api = {
		openPanel = openPanel, closePanel = closePanel, setDock = setDock, viewOnBoard = viewOnBoard, clearView = clearView,
		panelName = function() return currentPanel and currentPanel.name or nil end,
		hasPill = function() return restorePill ~= nil end,
		restore = function() openPanel("Assets") end,
		isLocked = function() return locked end,
		state = function() return assetsState end,
		buttons = dockButtons,
	}
end
