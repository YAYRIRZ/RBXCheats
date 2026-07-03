local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local SHOP_ITEMS = {
	{
		Id = "PineTree",          -- id, который отправляется на сервер
		Name = "Сосна (PineTree)",-- отображаемое имя
		Price = 80,               -- цена за 1 штуку
		Currency = "Gold",        -- название валюты (только отображение)
		Icon = "rbxassetid://0",  -- можно вставить свой assetId иконки ёлки
	},
}

local CREDITS_TEXT = "Made by @TheZeroStudio"

local function round(x)
	return math.floor(x + 0.5)
end

local function formatNumber(n)
	local formatted = tostring(math.floor(n))
	local k
	repeat
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
	until k == 0
	return formatted
end

local function tween(obj, props, time, style, dir)
	local ti = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, ti, props)
	t:Play()
	return t
end

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = parent
	return c
end

local function makeStroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(255, 255, 255)
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.7
	s.Parent = parent
	return s
end

local function makeGradient(parent, colorSeq, rotation)
	local g = Instance.new("UIGradient")
	g.Color = colorSeq
	g.Rotation = rotation or 90
	g.Parent = parent
	return g
end

local oldGui = playerGui:FindFirstChild("TreeShopGui")
if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TreeShopGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 50
screenGui.Parent = playerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.fromOffset(58, 58)
toggleButton.Position = UDim2.new(0, 20, 0.5, -29)
toggleButton.AnchorPoint = Vector2.new(0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 130, 65)
toggleButton.AutoButtonColor = false
toggleButton.Text = "🎄"
toggleButton.TextSize = 28
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.ZIndex = 10
toggleButton.Parent = screenGui
makeCorner(toggleButton, 29)
makeStroke(toggleButton, Color3.fromRGB(255, 255, 255), 2, 0.5)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.fromOffset(380, 420)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 28, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
makeCorner(mainFrame, 16)
makeStroke(mainFrame, Color3.fromRGB(60, 200, 110), 1.5, 0.4)

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 54)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 60, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
makeCorner(titleBar, 16)
makeGradient(titleBar, ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 90, 45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 50, 30)),
}), 0)

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 16)
titleBarFix.Position = UDim2.new(0, 0, 1, -16)
titleBarFix.BackgroundColor3 = titleBar.BackgroundColor3
titleBarFix.BorderSizePixel = 0
titleBarFix.ZIndex = 1
titleBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.Text = "🎄 Магазин Ёлок"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 2
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(34, 34)
closeButton.Position = UDim2.new(1, -44, 0.5, -17)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.AutoButtonColor = false
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.ZIndex = 2
closeButton.Parent = titleBar
makeCorner(closeButton, 8)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ItemsScroll"
scrollFrame.Size = UDim2.new(1, -20, 1, -170)
scrollFrame.Position = UDim2.new(0, 10, 0, 64)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 200, 110)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local bottomPanel = Instance.new("Frame")
bottomPanel.Size = UDim2.new(1, -20, 0, 96)
bottomPanel.Position = UDim2.new(0, 10, 1, -104)
bottomPanel.BackgroundColor3 = Color3.fromRGB(32, 38, 35)
bottomPanel.BorderSizePixel = 0
bottomPanel.Parent = mainFrame
makeCorner(bottomPanel, 12)
makeStroke(bottomPanel, Color3.fromRGB(60, 200, 110), 1, 0.6)

local qtyLabel = Instance.new("TextLabel")
qtyLabel.BackgroundTransparency = 1
qtyLabel.Position = UDim2.new(0, 12, 0, 8)
qtyLabel.Size = UDim2.new(0, 200, 0, 18)
qtyLabel.Text = "Количество для покупки:"
qtyLabel.Font = Enum.Font.Gotham
qtyLabel.TextSize = 13
qtyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
qtyLabel.TextXAlignment = Enum.TextXAlignment.Left
qtyLabel.Parent = bottomPanel

local qtyRow = Instance.new("Frame")
qtyRow.BackgroundTransparency = 1
qtyRow.Position = UDim2.new(0, 12, 0, 28)
qtyRow.Size = UDim2.new(0, 150, 0, 34)
qtyRow.Parent = bottomPanel

local function makeStepButton(text, posX)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(34, 34)
	b.Position = UDim2.new(0, posX, 0, 0)
	b.BackgroundColor3 = Color3.fromRGB(50, 60, 55)
	b.AutoButtonColor = false
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Parent = qtyRow
	makeCorner(b, 8)
	return b
end

local minusBtn = makeStepButton("-", 0)
local qtyBox = Instance.new("TextBox")
qtyBox.Size = UDim2.fromOffset(74, 34)
qtyBox.Position = UDim2.new(0, 38, 0, 0)
qtyBox.BackgroundColor3 = Color3.fromRGB(20, 24, 22)
qtyBox.Text = "1"
qtyBox.Font = Enum.Font.GothamBold
qtyBox.TextSize = 16
qtyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
qtyBox.ClearTextOnFocus = false
qtyBox.PlaceholderText = "1"
qtyBox.Parent = qtyRow
makeCorner(qtyBox, 8)
makeStroke(qtyBox, Color3.fromRGB(60, 200, 110), 1, 0.6)

local plusBtn = makeStepButton("+", 116)

local presetRow = Instance.new("Frame")
presetRow.BackgroundTransparency = 1
presetRow.Position = UDim2.new(0, 172, 0, 28)
presetRow.Size = UDim2.new(1, -184, 0, 34)
presetRow.Parent = bottomPanel

local presetLayout = Instance.new("UIListLayout")
presetLayout.FillDirection = Enum.FillDirection.Horizontal
presetLayout.Padding = UDim.new(0, 6)
presetLayout.SortOrder = Enum.SortOrder.LayoutOrder
presetLayout.Parent = presetRow

local presetValues = { 1, 5, 10, 25 }
for _, v in ipairs(presetValues) do
	local pb = Instance.new("TextButton")
	pb.Size = UDim2.new(0, 40, 1, 0)
	pb.BackgroundColor3 = Color3.fromRGB(45, 90, 60)
	pb.AutoButtonColor = false
	pb.Text = "x" .. v
	pb.Font = Enum.Font.GothamBold
	pb.TextSize = 13
	pb.TextColor3 = Color3.fromRGB(255, 255, 255)
	pb.Parent = presetRow
	makeCorner(pb, 8)
	pb.MouseButton1Click:Connect(function()
		qtyBox.Text = tostring(v)
	end)
end

local statusLabel = Instance.new("TextLabel")
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0, 12, 1, -28)
statusLabel.Size = UDim2.new(1, -24, 0, 18)
statusLabel.Text = ""
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = bottomPanel

local creditsLabel = Instance.new("TextLabel")
creditsLabel.Name = "Credits"
creditsLabel.BackgroundTransparency = 1
creditsLabel.Size = UDim2.new(1, 0, 0, 16)
creditsLabel.Position = UDim2.new(0, 0, 1, 2)
creditsLabel.Text = CREDITS_TEXT
creditsLabel.Font = Enum.Font.GothamMedium
creditsLabel.TextSize = 11
creditsLabel.TextColor3 = Color3.fromRGB(90, 200, 130)
creditsLabel.TextTransparency = 0.15
creditsLabel.Parent = mainFrame

local selectedItem = SHOP_ITEMS[1]

local itemCards = {}
local buyCurrentSelectionRef

local function selectItem(item, card)
	selectedItem = item
	for _, c in pairs(itemCards) do
		c.Stroke.Transparency = 0.6
		c.Stroke.Color = Color3.fromRGB(255, 255, 255)
		c.Frame.BackgroundColor3 = Color3.fromRGB(36, 42, 39)
	end
	card.Stroke.Transparency = 0
	card.Stroke.Color = Color3.fromRGB(90, 220, 130)
	card.Frame.BackgroundColor3 = Color3.fromRGB(30, 55, 38)
end

for i, item in ipairs(SHOP_ITEMS) do
	local card = Instance.new("Frame")
	card.Name = item.Id
	card.Size = UDim2.new(1, -6, 0, 84)
	card.BackgroundColor3 = Color3.fromRGB(36, 42, 39)
	card.BorderSizePixel = 0
	card.LayoutOrder = i
	card.Parent = scrollFrame
	makeCorner(card, 12)
	local stroke = makeStroke(card, Color3.fromRGB(255, 255, 255), 1.5, 0.6)

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.fromOffset(60, 60)
	icon.Position = UDim2.new(0, 12, 0.5, -30)
	icon.BackgroundColor3 = Color3.fromRGB(20, 60, 35)
	icon.Image = item.Icon or ""
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = card
	makeCorner(icon, 10)

	local iconFallback = Instance.new("TextLabel")
	iconFallback.BackgroundTransparency = 1
	iconFallback.Size = UDim2.fromScale(1, 1)
	iconFallback.Text = "🎄"
	iconFallback.TextSize = 30
	iconFallback.Font = Enum.Font.GothamBold
	iconFallback.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconFallback.Parent = icon

	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 84, 0, 12)
	nameLabel.Size = UDim2.new(1, -190, 0, 22)
	nameLabel.Text = item.Name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 16
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = card

	local priceLabel = Instance.new("TextLabel")
	priceLabel.BackgroundTransparency = 1
	priceLabel.Position = UDim2.new(0, 84, 0, 36)
	priceLabel.Size = UDim2.new(1, -190, 0, 20)
	priceLabel.Text = string.format("💰 %s %s / шт.", formatNumber(item.Price), item.Currency)
	priceLabel.Font = Enum.Font.Gotham
	priceLabel.TextSize = 14
	priceLabel.TextColor3 = Color3.fromRGB(255, 210, 90)
	priceLabel.TextXAlignment = Enum.TextXAlignment.Left
	priceLabel.Parent = card

	local totalLabel = Instance.new("TextLabel")
	totalLabel.Name = "TotalLabel"
	totalLabel.BackgroundTransparency = 1
	totalLabel.Position = UDim2.new(0, 84, 0, 58)
	totalLabel.Size = UDim2.new(1, -190, 0, 18)
	totalLabel.Text = "Итого: " .. formatNumber(item.Price) .. " " .. item.Currency
	totalLabel.Font = Enum.Font.GothamMedium
	totalLabel.TextSize = 12
	totalLabel.TextColor3 = Color3.fromRGB(160, 220, 180)
	totalLabel.TextXAlignment = Enum.TextXAlignment.Left
	totalLabel.Parent = card

	local buyBtn = Instance.new("TextButton")
	buyBtn.Size = UDim2.fromOffset(84, 40)
	buyBtn.Position = UDim2.new(1, -96, 0.5, -20)
	buyBtn.BackgroundColor3 = Color3.fromRGB(45, 160, 90)
	buyBtn.AutoButtonColor = false
	buyBtn.Text = "Купить"
	buyBtn.Font = Enum.Font.GothamBold
	buyBtn.TextSize = 15
	buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyBtn.Parent = card
	makeCorner(buyBtn, 10)

	itemCards[item.Id] = { Frame = card, Stroke = stroke, TotalLabel = totalLabel }

	card.MouseEnter:Connect(function()
		if selectedItem ~= item then
			tween(card, { BackgroundColor3 = Color3.fromRGB(42, 50, 46) }, 0.15)
		end
	end)
	card.MouseLeave:Connect(function()
		if selectedItem ~= item then
			tween(card, { BackgroundColor3 = Color3.fromRGB(36, 42, 39) }, 0.15)
		end
	end)

	local selectDetector = Instance.new("TextButton")
	selectDetector.BackgroundTransparency = 1
	selectDetector.Size = UDim2.new(1, -96, 1, 0)
	selectDetector.Text = ""
	selectDetector.ZIndex = 0
	selectDetector.Parent = card
	selectDetector.MouseButton1Click:Connect(function()
		selectItem(item, itemCards[item.Id])
	end)

	buyBtn.MouseButton1Click:Connect(function()
		selectItem(item, itemCards[item.Id])
		buyCurrentSelectionRef(item)
	end)

	if i == 1 then
		selectItem(item, itemCards[item.Id])
	end
end

local MIN_QTY = 1
local MAX_QTY = 999 -- ограничение чтобы не сломать сервер случайным вводом

local function getQty()
	local n = tonumber(qtyBox.Text)
	if not n then
		return MIN_QTY
	end
	n = round(n)
	if n < MIN_QTY then n = MIN_QTY end
	if n > MAX_QTY then n = MAX_QTY end
	return n
end

local function updateTotals()
	local qty = getQty()
	for _, item in ipairs(SHOP_ITEMS) do
		local card = itemCards[item.Id]
		if card then
			local total = item.Price * qty
			card.TotalLabel.Text = string.format("Итого за %d шт.: %s %s", qty, formatNumber(total), item.Currency)
		end
	end
end

qtyBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = qtyBox.Text:gsub("%D", "")
	if filtered ~= qtyBox.Text then
		qtyBox.Text = filtered
	end
	updateTotals()
end)

qtyBox.FocusLost:Connect(function()
	qtyBox.Text = tostring(getQty())
	updateTotals()
end)

minusBtn.MouseButton1Click:Connect(function()
	qtyBox.Text = tostring(math.max(MIN_QTY, getQty() - 1))
	updateTotals()
end)

plusBtn.MouseButton1Click:Connect(function()
	qtyBox.Text = tostring(math.min(MAX_QTY, getQty() + 1))
	updateTotals()
end)

updateTotals()

local remoteEvent = workspace:WaitForChild("ItemBoughtFromShop")

local isBuying = false

local function setStatus(text, color)
	statusLabel.Text = text
	statusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

local function buyCurrentSelection(item)
	if isBuying then
		return
	end

	local qty = getQty()
	if qty < MIN_QTY then
		setStatus("Некорректное количество!", Color3.fromRGB(255, 90, 90))
		return
	end

	isBuying = true
	setStatus(("Покупаем %d x %s..."):format(qty, item.Name), Color3.fromRGB(230, 200, 100))

	local args = { item.Id, qty }

	local ok, result = pcall(function()
		return remoteEvent:InvokeServer(unpack(args))
	end)

	if ok then
		if result == false then
			setStatus("Сервер отклонил покупку (недостаточно " .. item.Currency .. "?)", Color3.fromRGB(255, 110, 110))
		else
			setStatus(("Успешно куплено: %d x %s ✅"):format(qty, item.Name), Color3.fromRGB(120, 230, 150))
		end
	else
		setStatus("Ошибка при покупке: " .. tostring(result), Color3.fromRGB(255, 110, 110))
	end

	isBuying = false
end

buyCurrentSelectionRef = buyCurrentSelection

local isOpen = false

local function openShop()
	isOpen = true
	mainFrame.Visible = true
	mainFrame.Size = UDim2.fromOffset(380, 0)
	mainFrame.BackgroundTransparency = 1
	tween(mainFrame, { Size = UDim2.fromOffset(380, 420), BackgroundTransparency = 0 }, 0.25, Enum.EasingStyle.Back)
end

local function closeShop()
	isOpen = false
	local t = tween(mainFrame, { Size = UDim2.fromOffset(380, 0), BackgroundTransparency = 1 }, 0.2)
	t.Completed:Connect(function()
		if not isOpen then
			mainFrame.Visible = false
		end
	end)
end

toggleButton.MouseButton1Click:Connect(function()
	if isOpen then
		closeShop()
	else
		openShop()
	end
end)

closeButton.MouseButton1Click:Connect(function()
	closeShop()
end)

-- маленькая анимация наведения на кнопки
local function hoverEffect(btn, hoverColor, normalColor)
	btn.MouseEnter:Connect(function()
		tween(btn, { BackgroundColor3 = hoverColor }, 0.12)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, { BackgroundColor3 = normalColor }, 0.12)
	end)
end

hoverEffect(toggleButton, Color3.fromRGB(45, 160, 90), Color3.fromRGB(35, 130, 65))
hoverEffect(closeButton, Color3.fromRGB(210, 70, 70), Color3.fromRGB(180, 50, 50))
hoverEffect(minusBtn, Color3.fromRGB(70, 80, 75), Color3.fromRGB(50, 60, 55))
hoverEffect(plusBtn, Color3.fromRGB(70, 80, 75), Color3.fromRGB(50, 60, 55))

for _, item in ipairs(SHOP_ITEMS) do
	local card = itemCards[item.Id]
	local buyBtn
	for _, child in ipairs(card.Frame:GetChildren()) do
		if child:IsA("TextButton") and child.Text == "Купить" then
			buyBtn = child
			break
		end
	end
	if buyBtn then
		hoverEffect(buyBtn, Color3.fromRGB(55, 190, 105), Color3.fromRGB(45, 160, 90))
	end
end

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.J then
		if isOpen then
			closeShop()
		else
			openShop()
		end
	end
end)

--[[
    ============================================================
     Made by @TheZeroStudio
    ============================================================
]]
