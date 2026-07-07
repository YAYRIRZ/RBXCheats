--[[
    ZeroHub Icon (SVG) - можно использовать для загрузки как ImageLabel
    Для использования в Roblox:
    1. Загрузи этот SVG на Roblox как Decal/Image
    2. Или используй base64 encoded version ниже
]]

local ZEROHUB_ICON_SVG = [[
<svg width="200" height="200" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#00B4FF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0078C8;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="textGradient" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#FFFFFF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#E0F4FF;stop-opacity:1" />
    </linearGradient>
    <filter id="glow">
      <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
      <feMerge>
        <feMergeNode in="coloredBlur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>
  <rect x="10" y="10" width="180" height="180" rx="30" ry="30" fill="url(#bgGradient)"/>
  <rect x="15" y="15" width="170" height="170" rx="27" ry="27" fill="none" stroke="#FFFFFF" stroke-width="2" stroke-opacity="0.3"/>
  <g filter="url(#glow)">
    <path d="M 40 60 L 90 60 L 90 75 L 55 125 L 90 125 L 90 140 L 40 140 L 40 125 L 75 75 L 40 75 Z" fill="url(#textGradient)"/>
    <path d="M 100 60 L 115 60 L 115 92 L 145 92 L 145 60 L 160 60 L 160 140 L 145 140 L 145 107 L 115 107 L 115 140 L 100 140 Z" fill="url(#textGradient)"/>
  </g>
  <line x1="50" y1="160" x2="150" y2="160" stroke="#FFFFFF" stroke-width="3" stroke-opacity="0.6" stroke-linecap="round"/>
</svg>
]]

--[[
    ZeroHub - Advanced Script Hub for Roblox
    Version: 1.0
    Colors: Cyan, Blue, Black
    Features: Player Mods + Infinite Blocks
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Local Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Settings
local settings = {
    -- Player
    jumpPower = 50,
    walkSpeed = 16,
    gravity = 196.2,
    fly = false,
    noclip = false,
    godMode = false,
    infiniteJump = false,
    
    -- Inf Blocks
    infiniteBlocks = false,
    autoBuild = false,
    blockMultiplier = 1
}

-- Colors
local colors = {
    bg = Color3.fromRGB(20, 25, 35),
    panel = Color3.fromRGB(30, 35, 45),
    button = Color3.fromRGB(40, 50, 65),
    buttonHover = Color3.fromRGB(50, 65, 85),
    accent = Color3.fromRGB(0, 180, 255),
    accentDark = Color3.fromRGB(0, 120, 200),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(180, 190, 200),
    success = Color3.fromRGB(0, 255, 150),
    danger = Color3.fromRGB(255, 80, 80)
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZeroHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 450)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
MainFrame.BackgroundColor3 = colors.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Gradient Background (using UIGradient)
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 20, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 25, 40))
}
mainGradient.Rotation = 135
mainGradient.Parent = MainFrame

-- Corner rounding
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

-- Stroke border
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = colors.accent
mainStroke.Thickness = 2
mainStroke.Transparency = 0.7
mainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = colors.panel
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

-- Title Gradient
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 180))
}
titleGradient.Rotation = 90
titleGradient.Parent = TitleBar

-- Logo (ZH SVG simulation using TextLabel)
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 50, 0, 50)
LogoFrame.Position = UDim2.new(0, 10, 0, 0)
LogoFrame.BackgroundTransparency = 1
LogoFrame.Parent = TitleBar

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "ZH"
LogoText.TextColor3 = colors.text
LogoText.TextSize = 28
LogoText.Font = Enum.Font.GothamBlack
LogoText.Parent = LogoFrame

-- Title Text
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -150, 1, 0)
Title.Position = UDim2.new(0, 65, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZeroHub"
Title.TextColor3 = colors.text
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Control Buttons
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -80, 0, 7)
MinimizeButton.BackgroundColor3 = colors.button
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = colors.text
MinimizeButton.TextSize = 24
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -42, 0, 7)
CloseButton.BackgroundColor3 = colors.danger
CloseButton.Text = "✕"
CloseButton.TextColor3 = colors.text
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = CloseButton

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 40)
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -20, 1, -120)
ContentArea.Position = UDim2.new(0, 10, 0, 110)
ContentArea.BackgroundColor3 = colors.panel
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = ContentArea

-- Tab System
local tabs = {}
local currentTab = nil

local function createTab(name, icon)
    local tab = {}
    
    -- Tab Button
    tab.button = Instance.new("TextButton")
    tab.button.Size = UDim2.new(0.5, -5, 1, 0)
    tab.button.Position = UDim2.new(#tabs * 0.5, #tabs * 5, 0, 0)
    tab.button.BackgroundColor3 = colors.button
    tab.button.Text = icon .. " " .. name
    tab.button.TextColor3 = colors.text
    tab.button.TextSize = 16
    tab.button.Font = Enum.Font.GothamBold
    tab.button.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tab.button
    
    -- Tab Content
    tab.content = Instance.new("ScrollingFrame")
    tab.content.Size = UDim2.new(1, -20, 1, -20)
    tab.content.Position = UDim2.new(0, 10, 0, 10)
    tab.content.BackgroundTransparency = 1
    tab.content.BorderSizePixel = 0
    tab.content.ScrollBarThickness = 4
    tab.content.ScrollBarImageColor3 = colors.accent
    tab.content.Visible = false
    tab.content.Parent = ContentArea
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = tab.content
    
    tab.listLayout = listLayout
    
    -- Update canvas size
    tab.content.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.content.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)
    
    table.insert(tabs, tab)
    return tab
end

local function switchTab(tab)
    for _, t in ipairs(tabs) do
        t.content.Visible = false
        t.button.BackgroundColor3 = colors.button
    end
    tab.content.Visible = true
    tab.button.BackgroundColor3 = colors.accent
    currentTab = tab
end

-- Create Tabs
local playerTab = createTab("Player", "👤")
local infBlocksTab = createTab("Inf Blocks", "📦")

-- Tab Click Handlers
playerTab.button.MouseButton1Click:Connect(function()
    switchTab(playerTab)
end)

infBlocksTab.button.MouseButton1Click:Connect(function()
    switchTab(infBlocksTab)
end)

-- Helper: Create Toggle Button
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = colors.button
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = colors.text
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 55, 0, 28)
    button.Position = UDim2.new(1, -65, 0.5, -14)
    button.BackgroundColor3 = colors.buttonHover
    button.Text = "OFF"
    button.TextColor3 = colors.textDim
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    
    local active = false
    
    button.MouseButton1Click:Connect(function()
        active = not active
        if active then
            button.BackgroundColor3 = colors.success
            button.Text = "ON"
            button.TextColor3 = Color3.fromRGB(0, 50, 30)
        else
            button.BackgroundColor3 = colors.buttonHover
            button.Text = "OFF"
            button.TextColor3 = colors.textDim
        end
        callback(active)
    end)
    
    return button
end

-- Helper: Create Slider
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = colors.button
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = colors.text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    sliderBg.Position = UDim2.new(0, 15, 0, 35)
    sliderBg.BackgroundColor3 = colors.bg
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = colors.accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = colors.text
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = sliderButton
    
    local dragging = false
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = mousePos.X - sliderBg.AbsolutePosition.X
            local percentage = math.clamp(relativePos / sliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderButton.Position = UDim2.new(percentage, -10, 0.5, -10)
            label.Text = text .. ": " .. value
            
            callback(value)
        end
    end)
    
    return frame
end

-- PLAYER TAB FUNCTIONS
local function toggleFly(enabled)
    settings.fly = enabled
    if enabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "ZeroHub_Fly"
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        RunService:BindToRenderStep("ZeroHub_Fly", 1, function()
            if not settings.fly then return end
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            bodyVelocity.Velocity = moveDir * settings.walkSpeed
        end)
    else
        local fly = rootPart:FindFirstChild("ZeroHub_Fly")
        if fly then fly:Destroy() end
        RunService:UnbindFromRenderStep("ZeroHub_Fly")
    end
end

local function toggleNoclip(enabled)
    settings.noclip = enabled
    if enabled then
        RunService:BindToRenderStep("ZeroHub_Noclip", 1, function()
            if not settings.noclip then return end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("ZeroHub_Noclip")
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function toggleGodMode(enabled)
    settings.godMode = enabled
    if enabled then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end

local function toggleInfiniteJump(enabled)
    settings.infiniteJump = enabled
end

UserInputService.JumpRequest:Connect(function()
    if settings.infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- INF BLOCKS TAB FUNCTIONS
local function toggleInfiniteBlocks(enabled)
    settings.infiniteBlocks = enabled
    if enabled then
        -- Try to find blocks in player's inventory or game
        spawn(function()
            while settings.infiniteBlocks do
                pcall(function()
                    -- Try to manipulate block counts
                    local playerData = player:FindFirstChild("PlayerData") or player:FindFirstChild("leaderstats")
                    if playerData then
                        local blocks = playerData:FindFirstChild("Blocks") or playerData:FindFirstChild("blocks")
                        if blocks then
                            blocks.Value = 999999
                        end
                    end
                    
                    -- Try to find workspace blocks folder
                    local blocksFolder = workspace:FindFirstChild("Blocks") or workspace:FindFirstChild("PlayerBlocks")
                    if blocksFolder then
                        for _, block in pairs(blocksFolder:GetChildren()) do
                            if block:IsA("NumberValue") or block:IsA("IntValue") then
                                block.Value = 999999
                            end
                        end
                    end
                end)
                wait(0.5)
            end
        end)
    end
end

-- Populate Player Tab
createSlider(playerTab.content, "Jump Power", 50, 500, 50, function(value)
    settings.jumpPower = value
    humanoid.JumpPower = value
end)

createSlider(playerTab.content, "Walk Speed", 16, 500, 16, function(value)
    settings.walkSpeed = value
    humanoid.WalkSpeed = value
end)

createSlider(playerTab.content, "Gravity", 0, 500, 196, function(value)
    settings.gravity = value
    workspace.Gravity = value
end)

createToggle(playerTab.content, "Fly (WASD + Space/Shift)", toggleFly)
createToggle(playerTab.content, "Noclip", toggleNoclip)
createToggle(playerTab.content, "God Mode", toggleGodMode)
createToggle(playerTab.content, "Infinite Jump", toggleInfiniteJump)

-- Populate Inf Blocks Tab
createToggle(infBlocksTab.content, "Infinite Blocks", toggleInfiniteBlocks)

-- Info label for Inf Blocks
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 80)
infoLabel.BackgroundColor3 = colors.button
infoLabel.BorderSizePixel = 0
infoLabel.Text = "ℹ️ Infinite Blocks will attempt to:\n• Set block count to 999999\n• Bypass block limits\n• Works with most block types\n\nNote: May not work on all servers"
infoLabel.TextColor3 = colors.textDim
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = infBlocksTab.content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoLabel

-- Control Button Handlers
local minimized = false

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 550, 0, 50)
        ContentArea.Visible = false
        TabContainer.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 550, 0, 450)
        ContentArea.Visible = true
        TabContainer.Visible = true
        MinimizeButton.Text = "−"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    -- Cleanup
    RunService:UnbindFromRenderStep("ZeroHub_Fly")
    RunService:UnbindFromRenderStep("ZeroHub_Noclip")
end)

-- Initialize
switchTab(playerTab)

print("⚡ ZeroHub v1.0 loaded successfully!")
print("📋 Tabs: Player, Inf Blocks")
print("🎨 Theme: Cyan/Blue/Black with gradients")
