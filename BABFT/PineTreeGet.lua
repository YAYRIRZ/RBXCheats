local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ITEM_ID = "PineTree"
local ITEM_PRICE = 80
local CURRENCY = "Gold"
local MAX_QTY = 999
local MIN_QTY = 1

local COLOR_BLACK = Color3.fromRGB(6, 9, 14)
local COLOR_NAVY_DARK = Color3.fromRGB(11, 18, 32)
local COLOR_NAVY = Color3.fromRGB(16, 26, 46)
local COLOR_NAVY_LIGHT = Color3.fromRGB(22, 35, 60)
local COLOR_BLUE = Color3.fromRGB(45, 130, 245)
local COLOR_BLUE_BRIGHT = Color3.fromRGB(80, 165, 255)
local COLOR_BLUE_DIM = Color3.fromRGB(28, 70, 130)
local COLOR_TEXT = Color3.fromRGB(225, 235, 250)
local COLOR_TEXT_DIM = Color3.fromRGB(140, 160, 190)

local oldGui = playerGui:FindFirstChild("PineTreeShopGui")
if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PineTreeShopGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 50
screenGui.Parent = playerGui

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function stroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness
	s.Transparency = transparency or 0
	s.Parent = parent
	return s
end

local function gradient(parent, sequence, rotation)
	local g = Instance.new("UIGradient")
	g.Color = sequence
	g.Rotation = rotation or 90
	g.Parent = parent
	return g
end

local function tween(obj, props, time)
	local ti = TweenInfo.new(time or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, ti, props)
	t:Play()
	return t
end

local NORMAL_SIZE = UDim2.fromOffset(320, 320)
local MAXIMIZED_SIZE = UDim2.fromOffset(440, 420)
local MINIMIZED_SIZE = UDim2.fromOffset(320, 40)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = NORMAL_SIZE
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
mainFrame.BackgroundColor3 = COLOR_NAVY_DARK
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
corner(mainFrame, 18)
stroke(mainFrame, COLOR_BLUE_DIM, 1, 0.3)

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = COLOR_BLACK
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
corner(titleBar, 18)
gradient(titleBar, ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_NAVY),
	ColorSequenceKeypoint.new(1, COLOR_BLACK),
}), 0)

local titleBarMask = Instance.new("Frame")
titleBarMask.Size = UDim2.new(1, 0, 0, 18)
titleBarMask.Position = UDim2.new(0, 0, 1, -18)
titleBarMask.BackgroundColor3 = COLOR_BLACK
titleBarMask.BorderSizePixel = 0
titleBarMask.ZIndex = 1
titleBarMask.Parent = titleBar
gradient(titleBarMask, ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_NAVY),
	ColorSequenceKeypoint.new(1, COLOR_BLACK),
}), 0)

local titleIcon = Instance.new("Frame")
titleIcon.Size = UDim2.fromOffset(6, 20)
titleIcon.Position = UDim2.new(0, 14, 0.5, -10)
titleIcon.BackgroundColor3 = COLOR_BLUE
titleIcon.BorderSizePixel = 0
titleIcon.ZIndex = 2
titleIcon.Parent = titleBar
corner(titleIcon, 3)

local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -170, 1, 0)
titleLabel.Position = UDim2.new(0, 28, 0, 0)
titleLabel.Text = "PINE TREE SHOP"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextColor3 = COLOR_TEXT
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 2
titleLabel.Parent = titleBar

local function makeControlButton(offsetFromRight)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromOffset(30, 30)
	btn.Position = UDim2.new(1, offsetFromRight, 0.5, -15)
	btn.BackgroundColor3 = COLOR_NAVY_LIGHT
	btn.BackgroundTransparency = 1
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.ZIndex = 3
	btn.Parent = titleBar
	corner(btn, 8)
	return btn
end

local closeButton = makeControlButton(-38)
local maximizeButton = makeControlButton(-72)
local minimizeButton = makeControlButton(-106)

local function hoverHighlight(btn)
	btn.MouseEnter:Connect(function()
		tween(btn, { BackgroundTransparency = 0.85 }, 0.12)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, { BackgroundTransparency = 1 }, 0.12)
	end)
end

hoverHighlight(closeButton)
hoverHighlight(maximizeButton)
hoverHighlight(minimizeButton)

local closeIconA = Instance.new("Frame")
closeIconA.Size = UDim2.fromOffset(14, 2)
closeIconA.AnchorPoint = Vector2.new(0.5, 0.5)
closeIconA.Position = UDim2.fromScale(0.5, 0.5)
closeIconA.Rotation = 45
closeIconA.BackgroundColor3 = COLOR_BLUE_BRIGHT
closeIconA.BorderSizePixel = 0
closeIconA.ZIndex = 4
closeIconA.Parent = closeButton
corner(closeIconA, 1)

local closeIconB = closeIconA:Clone()
closeIconB.Rotation = -45
closeIconB.Parent = closeButton

local maximizeIcon = Instance.new("Frame")
maximizeIcon.Size = UDim2.fromOffset(13, 13)
maximizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
maximizeIcon.Position = UDim2.fromScale(0.5, 0.5)
maximizeIcon.BackgroundTransparency = 1
maximizeIcon.ZIndex = 4
maximizeIcon.Parent = maximizeButton
corner(maximizeIcon, 2)
stroke(maximizeIcon, COLOR_BLUE_BRIGHT, 2, 0)

local minimizeIcon = Instance.new("Frame")
minimizeIcon.Size = UDim2.fromOffset(14, 2)
minimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
minimizeIcon.Position = UDim2.fromScale(0.5, 0.5)
minimizeIcon.BackgroundColor3 = COLOR_BLUE_BRIGHT
minimizeIcon.BorderSizePixel = 0
minimizeIcon.ZIndex = 4
minimizeIcon.Parent = minimizeButton
corner(minimizeIcon, 1)

local bodyFrame = Instance.new("Frame")
bodyFrame.Name = "Body"
bodyFrame.Size = UDim2.new(1, 0, 1, -40)
bodyFrame.Position = UDim2.new(0, 0, 0, 40)
bodyFrame.BackgroundTransparency = 1
bodyFrame.Parent = mainFrame

local treeIconFrame = Instance.new("Frame")
treeIconFrame.Size = UDim2.fromOffset(40, 40)
treeIconFrame.Position = UDim2.new(0, 20, 0, 20)
treeIconFrame.BackgroundTransparency = 1
treeIconFrame.Parent = bodyFrame

local treeTop = Instance.new("Frame")
treeTop.Size = UDim2.fromOffset(12, 9)
treeTop.Position = UDim2.new(0.5, -6, 0, 2)
treeTop.BackgroundColor3 = COLOR_BLUE_BRIGHT
treeTop.BorderSizePixel = 0
treeTop.Parent = treeIconFrame
corner(treeTop, 2)

local treeMid = Instance.new("Frame")
treeMid.Size = UDim2.fromOffset(20, 9)
treeMid.Position = UDim2.new(0.5, -10, 0, 10)
treeMid.BackgroundColor3 = COLOR_BLUE
treeMid.BorderSizePixel = 0
treeMid.Parent = treeIconFrame
corner(treeMid, 2)

local treeBottom = Instance.new("Frame")
treeBottom.Size = UDim2.fromOffset(28, 9)
treeBottom.Position = UDim2.new(0.5, -14, 0, 18)
treeBottom.BackgroundColor3 = COLOR_BLUE_DIM
treeBottom.BorderSizePixel = 0
treeBottom.Parent = treeIconFrame
corner(treeBottom, 2)

local treeTrunk = Instance.new("Frame")
treeTrunk.Size = UDim2.fromOffset(6, 8)
treeTrunk.Position = UDim2.new(0.5, -3, 0, 27)
treeTrunk.BackgroundColor3 = COLOR_NAVY_LIGHT
treeTrunk.BorderSizePixel = 0
treeTrunk.Parent = treeIconFrame
corner(treeTrunk, 2)

local itemNameLabel = Instance.new("TextLabel")
itemNameLabel.BackgroundTransparency = 1
itemNameLabel.Position = UDim2.new(0, 72, 0, 20)
itemNameLabel.Size = UDim2.new(1, -90, 0, 20)
itemNameLabel.Text = "PineTree"
itemNameLabel.Font = Enum.Font.GothamBold
itemNameLabel.TextSize = 18
itemNameLabel.TextColor3 = COLOR_TEXT
itemNameLabel.TextXAlignment = Enum.TextXAlignment.Left
itemNameLabel.Parent = bodyFrame

local itemPriceLabel = Instance.new("TextLabel")
itemPriceLabel.BackgroundTransparency = 1
itemPriceLabel.Position = UDim2.new(0, 72, 0, 42)
itemPriceLabel.Size = UDim2.new(1, -90, 0, 18)
itemPriceLabel.Text = ITEM_PRICE .. " " .. CURRENCY .. " / шт."
itemPriceLabel.Font = Enum.Font.Gotham
itemPriceLabel.TextSize = 13
itemPriceLabel.TextColor3 = COLOR_TEXT_DIM
itemPriceLabel.TextXAlignment = Enum.TextXAlignment.Left
itemPriceLabel.Parent = bodyFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -40, 0, 1)
divider.Position = UDim2.new(0, 20, 0, 76)
divider.BackgroundColor3 = COLOR_NAVY_LIGHT
divider.BorderSizePixel = 0
divider.Parent = bodyFrame

local qtyLabel = Instance.new("TextLabel")
qtyLabel.BackgroundTransparency = 1
qtyLabel.Position = UDim2.new(0, 20, 0, 92)
qtyLabel.Size = UDim2.new(1, -40, 0, 18)
qtyLabel.Text = "Количество (1 - " .. MAX_QTY .. ")"
qtyLabel.Font = Enum.Font.Gotham
qtyLabel.TextSize = 13
qtyLabel.TextColor3 = COLOR_TEXT_DIM
qtyLabel.TextXAlignment = Enum.TextXAlignment.Left
qtyLabel.Parent = bodyFrame

local qtyRow = Instance.new("Frame")
qtyRow.Position = UDim2.new(0, 20, 0, 116)
qtyRow.Size = UDim2.new(1, -40, 0, 40)
qtyRow.BackgroundTransparency = 1
qtyRow.Parent = bodyFrame

local minusButton = Instance.new("TextButton")
minusButton.Size = UDim2.fromOffset(40, 40)
minusButton.Position = UDim2.new(0, 0, 0, 0)
minusButton.BackgroundColor3 = COLOR_NAVY
minusButton.AutoButtonColor = false
minusButton.Text = "-"
minusButton.Font = Enum.Font.GothamBold
minusButton.TextSize = 22
minusButton.TextColor3 = COLOR_TEXT
minusButton.Parent = qtyRow
corner(minusButton, 10)
stroke(minusButton, COLOR_BLUE_DIM, 1, 0.4)

local qtyBox = Instance.new("TextBox")
qtyBox.Size = UDim2.new(1, -160, 1, 0)
qtyBox.Position = UDim2.new(0, 50, 0, 0)
qtyBox.BackgroundColor3 = COLOR_NAVY
qtyBox.Text = "1"
qtyBox.Font = Enum.Font.GothamBold
qtyBox.TextSize = 18
qtyBox.TextColor3 = COLOR_TEXT
qtyBox.ClearTextOnFocus = false
qtyBox.PlaceholderText = "1"
qtyBox.Parent = qtyRow
corner(qtyBox, 10)
stroke(qtyBox, COLOR_BLUE_DIM, 1, 0.4)

local plusButton = Instance.new("TextButton")
plusButton.Size = UDim2.fromOffset(40, 40)
plusButton.Position = UDim2.new(1, -40, 0, 0)
plusButton.BackgroundColor3 = COLOR_NAVY
plusButton.AutoButtonColor = false
plusButton.Text = "+"
plusButton.Font = Enum.Font.GothamBold
plusButton.TextSize = 22
plusButton.TextColor3 = COLOR_TEXT
plusButton.Parent = qtyRow
corner(plusButton, 10)
stroke(plusButton, COLOR_BLUE_DIM, 1, 0.4)

local function hoverColor(btn, from, to)
	btn.MouseEnter:Connect(function()
		tween(btn, { BackgroundColor3 = to }, 0.12)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, { BackgroundColor3 = from }, 0.12)
	end)
end

hoverColor(minusButton, COLOR_NAVY, COLOR_NAVY_LIGHT)
hoverColor(plusButton, COLOR_NAVY, COLOR_NAVY_LIGHT)

local totalLabel = Instance.new("TextLabel")
totalLabel.BackgroundTransparency = 1
totalLabel.Position = UDim2.new(0, 20, 0, 164)
totalLabel.Size = UDim2.new(1, -40, 0, 20)
totalLabel.Text = "Итого: " .. ITEM_PRICE .. " " .. CURRENCY
totalLabel.Font = Enum.Font.GothamMedium
totalLabel.TextSize = 14
totalLabel.TextColor3 = COLOR_BLUE_BRIGHT
totalLabel.TextXAlignment = Enum.TextXAlignment.Left
totalLabel.Parent = bodyFrame

local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(1, -40, 0, 46)
buyButton.Position = UDim2.new(0, 20, 0, 196)
buyButton.BackgroundColor3 = COLOR_BLUE
buyButton.AutoButtonColor = false
buyButton.Text = "Купить"
buyButton.Font = Enum.Font.GothamBold
buyButton.TextSize = 16
buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
buyButton.Parent = bodyFrame
corner(buyButton, 12)
gradient(buyButton, ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_BLUE_BRIGHT),
	ColorSequenceKeypoint.new(1, COLOR_BLUE),
}), 90)

buyButton.MouseEnter:Connect(function()
	tween(buyButton, { BackgroundColor3 = COLOR_BLUE_BRIGHT }, 0.12)
end)
buyButton.MouseLeave:Connect(function()
	tween(buyButton, { BackgroundColor3 = COLOR_BLUE }, 0.12)
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0, 20, 0, 248)
statusLabel.Size = UDim2.new(1, -40, 0, 18)
statusLabel.Text = ""
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextColor3 = COLOR_TEXT_DIM
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = bodyFrame

local creditsLabel = Instance.new("TextLabel")
creditsLabel.BackgroundTransparency = 1
creditsLabel.Position = UDim2.new(0, 0, 1, -22)
creditsLabel.Size = UDim2.new(1, 0, 0, 16)
creditsLabel.Text = "Made by @TheZeroStudio"
creditsLabel.Font = Enum.Font.GothamMedium
creditsLabel.TextSize = 11
creditsLabel.TextColor3 = COLOR_BLUE_DIM
creditsLabel.TextXAlignment = Enum.TextXAlignment.Center
creditsLabel.Parent = bodyFrame

local function clampQty(n)
	if n < MIN_QTY then
		return MIN_QTY
	elseif n > MAX_QTY then
		return MAX_QTY
	end
	return math.floor(n)
end

local function getQty()
	local n = tonumber(qtyBox.Text)
	if not n then
		return MIN_QTY
	end
	return clampQty(n)
end

local function updateTotal()
	local qty = getQty()
	totalLabel.Text = "Итого: " .. (ITEM_PRICE * qty) .. " " .. CURRENCY
end

qtyBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = qtyBox.Text:gsub("%D", "")
	if filtered ~= qtyBox.Text then
		qtyBox.Text = filtered
		return
	end
	updateTotal()
end)

qtyBox.FocusLost:Connect(function()
	qtyBox.Text = tostring(getQty())
	updateTotal()
end)

minusButton.MouseButton1Click:Connect(function()
	qtyBox.Text = tostring(clampQty(getQty() - 1))
	updateTotal()
end)

plusButton.MouseButton1Click:Connect(function()
	qtyBox.Text = tostring(clampQty(getQty() + 1))
	updateTotal()
end)

local isBuying = false

buyButton.MouseButton1Click:Connect(function()
	if isBuying then
		return
	end
	isBuying = true

	local qty = getQty()
	local args = { ITEM_ID, qty }

	statusLabel.Text = "Покупка..."
	statusLabel.TextColor3 = COLOR_BLUE_BRIGHT

	local ok, result = pcall(function()
		return workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(unpack(args))
	end)

	if ok and result ~= false then
		statusLabel.Text = "Куплено: " .. qty .. " x PineTree"
		statusLabel.TextColor3 = COLOR_BLUE_BRIGHT
	else
		statusLabel.Text = "Не удалось купить"
		statusLabel.TextColor3 = Color3.fromRGB(220, 90, 90)
	end

	isBuying = false
end)

local isMinimized = false
local isMaximized = false

minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		bodyFrame.Visible = false
		tween(mainFrame, { Size = MINIMIZED_SIZE }, 0.2)
	else
		bodyFrame.Visible = true
		tween(mainFrame, { Size = isMaximized and MAXIMIZED_SIZE or NORMAL_SIZE }, 0.2)
	end
end)

maximizeButton.MouseButton1Click:Connect(function()
	if isMinimized then
		isMinimized = false
		bodyFrame.Visible = true
	end
	isMaximized = not isMaximized
	tween(mainFrame, { Size = isMaximized and MAXIMIZED_SIZE or NORMAL_SIZE }, 0.2)
end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
	script:Destroy()
end)

local dragging = false
local dragInput
local dragStart
local startPos

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
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

updateTotal()
