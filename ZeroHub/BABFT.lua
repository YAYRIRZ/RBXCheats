--[[
    ZeroHub v1.4 - BABFT Infinite Blocks
    Based on discovered remotes from game analysis
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Local Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Debug log
local debugLog = {}
local function log(msg)
    table.insert(debugLog, os.date("%H:%M:%S") .. " - " .. msg)
    print("[ZeroHub] " .. msg)
end

-- Settings
local settings = {
    jumpPower = 50,
    walkSpeed = 16,
    gravity = 196.2,
    fly = false,
    noclip = false,
    godMode = false,
    infiniteJump = false,
}

-- Colors
local colors = {
    bg = Color3.fromRGB(20, 25, 35),
    panel = Color3.fromRGB(30, 35, 45),
    button = Color3.fromRGB(40, 50, 65),
    buttonHover = Color3.fromRGB(50, 65, 85),
    accent = Color3.fromRGB(0, 180, 255),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(180, 190, 200),
    success = Color3.fromRGB(0, 255, 150),
    danger = Color3.fromRGB(255, 80, 80)
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZeroHub"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 600)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -300)
MainFrame.BackgroundColor3 = colors.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 35, 50))
}
mainGradient.Rotation = 135
mainGradient.Parent = MainFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = colors.accent
mainStroke.Thickness = 2
mainStroke.Transparency = 0.7
mainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = colors.panel
TitleBar.Parent = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZeroHub v1.4 - BABFT Inf Blocks"
Title.TextColor3 = colors.text
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -42, 0, 7)
CloseButton.BackgroundColor3 = colors.danger
CloseButton.Text = "X"
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
ContentArea.Parent = MainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = ContentArea

-- Tab System
local tabs = {}

local function createTab(name)
    local tab = {}
    
    tab.button = Instance.new("TextButton")
    tab.button.Size = UDim2.new(1/#tabs - 0.02, 0, 1, 0)
    tab.button.Position = UDim2.new((#tabs) * (1/#tabs), 0, 0, 0)
    tab.button.BackgroundColor3 = colors.button
    tab.button.Text = name
    tab.button.TextColor3 = colors.text
    tab.button.TextSize = 16
    tab.button.Font = Enum.Font.GothamBold
    tab.button.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tab.button
    
    tab.content = Instance.new("ScrollingFrame")
    tab.content.Size = UDim2.new(1, -20, 1, -20)
    tab.content.Position = UDim2.new(0, 10, 0, 10)
    tab.content.BackgroundTransparency = 1
    tab.content.ScrollBarThickness = 4
    tab.content.Visible = false
    tab.content.Parent = ContentArea
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = tab.content
    
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
end

local playerTab = createTab("Player")
local blocksTab = createTab("Inf Blocks")
local debugTab = createTab("Debug")

playerTab.button.MouseButton1Click:Connect(function() switchTab(playerTab) end)
blocksTab.button.MouseButton1Click:Connect(function() switchTab(blocksTab) end)
debugTab.button.MouseButton1Click:Connect(function() switchTab(debugTab) end)

-- Helper functions
local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = colors.accent
    button.Text = text
    button.TextColor3 = colors.text
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = colors.button
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
        button.BackgroundColor3 = active and colors.success or colors.buttonHover
        button.Text = active and "ON" or "OFF"
        button.TextColor3 = active and Color3.fromRGB(0, 50, 30) or colors.textDim
        callback(active)
    end)
    
    return button
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = colors.button
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
    sliderBg.Parent = frame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = colors.accent
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

-- PLAYER FUNCTIONS
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
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + rootPart.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - rootPart.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - rootPart.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + rootPart.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
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
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        RunService:UnbindFromRenderStep("ZeroHub_Noclip")
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

local function toggleGodMode(enabled)
    settings.godMode = enabled
    humanoid.MaxHealth = enabled and math.huge or 100
    humanoid.Health = humanoid.MaxHealth
end

local function toggleInfiniteJump(enabled)
    settings.infiniteJump = enabled
end

UserInputService.JumpRequest:Connect(function()
    if settings.infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- INFINITE BLOCKS METHODS (Based on discovered remotes)

-- Method 1: QueueBlocksRequest spam
local function queueBlocksSpam()
    log("Method 1: QueueBlocksRequest spam")
    
    local queueRemote = ReplicatedStorage:FindFirstChild("InputLocalScript", true)
    if queueRemote then
        queueRemote = queueRemote:FindFirstChild("QueueBlocksRequest")
    end
    
    if not queueRemote then
        log("ERROR: QueueBlocksRequest not found")
        return
    end
    
    log("Found QueueBlocksRequest, spamming...")
    
    for i = 1, 100 do
        pcall(function()
            -- Try different argument formats
            queueRemote:FireServer("WoodBlock", 1)
            queueRemote:FireServer("Wood Block", 1)
            queueRemote:FireServer({blockType = "WoodBlock", count = 1})
            queueRemote:FireServer(1, "WoodBlock")
        end)
        wait(0.05)
    end
    
    log("QueueBlocksRequest spam complete")
end

-- Method 2: BlockRequestsRemote spam
local function blockRequestsSpam()
    log("Method 2: BlockRequestsRemote spam")
    
    local blockRemote = workspace:FindFirstChild("BlockRequestsRemote")
    
    if not blockRemote then
        log("ERROR: BlockRequestsRemote not found")
        return
    end
    
    log("Found BlockRequestsRemote, spamming...")
    
    for i = 1, 100 do
        pcall(function()
            blockRemote:FireServer("WoodBlock", 1)
            blockRemote:FireServer("Wood Block", 1)
            blockRemote:FireServer({type = "WoodBlock", amount = 1})
        end)
        wait(0.05)
    end
    
    log("BlockRequestsRemote spam complete")
end

-- Method 3: InstaLoadFunction
local function instaLoadBypass()
    log("Method 3: InstaLoadFunction bypass")
    
    local instaLoad = workspace:FindFirstChild("InstaLoadFunction")
    
    if not instaLoad then
        log("ERROR: InstaLoadFunction not found")
        return
    end
    
    log("Found InstaLoadFunction, attempting bypass...")
    
    pcall(function()
        -- Try to load a build with many blocks
        local result = instaLoad:InvokeServer("default", 999999)
        log("InstaLoad result: " .. tostring(result))
    end)
    
    log("InstaLoadFunction bypass complete")
end

-- Method 4: ItemBoughtFromShop (from GitHub script)
local function itemBoughtSpam()
    log("Method 4: ItemBoughtFromShop spam (GitHub method)")
    
    local buyRemote = workspace:FindFirstChild("ItemBoughtFromShop")
    
    if not buyRemote then
        log("ERROR: ItemBoughtFromShop not found")
        return
    end
    
    log("Found ItemBoughtFromShop, spamming chests...")
    
    -- Based on GitHub script: workspace.ItemBoughtFromShop:InvokeServer('Winter Chest', 6)
    for i = 1, 50 do
        pcall(function()
            buyRemote:InvokeServer("Winter Chest", 6)
            buyRemote:InvokeServer("Basic Chest", 1)
            buyRemote:InvokeServer("Gold Chest", 10)
        end)
        wait(0.1)
    end
    
    log("ItemBoughtFromShop spam complete")
end

-- Method 5: SaveBoatData manipulation
local function saveBoatDataManip()
    log("Method 5: SaveBoatData manipulation")
    
    local saveRemote = workspace:FindFirstChild("SaveBoatData")
    
    if not saveRemote then
        log("ERROR: SaveBoatData not found")
        return
    end
    
    log("Found SaveBoatData, attempting manipulation...")
    
    pcall(function()
        -- Try to save boat data with infinite blocks
        local boatData = {
            blocks = {},
            blockCount = 999999
        }
        
        -- Add many blocks to the data
        for i = 1, 1000 do
            table.insert(boatData.blocks, {
                type = "WoodBlock",
                position = Vector3.new(i, 0, 0),
                rotation = CFrame.new()
            })
        end
        
        local result = saveRemote:InvokeServer(boatData)
        log("SaveBoatData result: " .. tostring(result))
    end)
    
    log("SaveBoatData manipulation complete")
end

-- Method 6: Combined approach
local function combinedApproach()
    log("Method 6: Combined approach (all methods)")
    
    log("Running ItemBoughtSpam...")
    itemBoughtSpam()
    wait(1)
    
    log("Running QueueBlocksSpam...")
    queueBlocksSpam()
    wait(1)
    
    log("Running BlockRequestsSpam...")
    blockRequestsSpam()
    wait(1)
    
    log("Running InstaLoadBypass...")
    instaLoadBypass()
    wait(1)
    
    log("Running SaveBoatDataManip...")
    saveBoatDataManip()
    
    log("Combined approach complete")
end

-- Populate tabs
createSlider(playerTab.content, "Jump Power", 50, 500, 50, function(v) humanoid.JumpPower = v end)
createSlider(playerTab.content, "Walk Speed", 16, 500, 16, function(v) humanoid.WalkSpeed = v end)
createSlider(playerTab.content, "Gravity", 0, 500, 196, function(v) workspace.Gravity = v end)
createToggle(playerTab.content, "Fly (WASD + Space/Shift)", toggleFly)
createToggle(playerTab.content, "Noclip", toggleNoclip)
createToggle(playerTab.content, "God Mode", toggleGodMode)
createToggle(playerTab.content, "Infinite Jump", toggleInfiniteJump)

-- Inf Blocks tab
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 100)
infoLabel.BackgroundColor3 = colors.button
infoLabel.Text = "[INFO] Infinite Blocks Methods\n\nBased on discovered remotes from your logs.\nTry each method separately or use Combined.\nCheck Debug tab for detailed logs."
infoLabel.TextColor3 = colors.textDim
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = blocksTab.content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoLabel

createButton(blocksTab.content, "1. QueueBlocksRequest Spam", queueBlocksSpam)
createButton(blocksTab.content, "2. BlockRequestsRemote Spam", blockRequestsSpam)
createButton(blocksTab.content, "3. InstaLoadFunction Bypass", instaLoadBypass)
createButton(blocksTab.content, "4. ItemBoughtFromShop Spam (GitHub)", itemBoughtSpam)
createButton(blocksTab.content, "5. SaveBoatData Manipulation", saveBoatDataManip)
createButton(blocksTab.content, "6. Combined Approach (All)", combinedApproach)

-- Debug tab
local debugTextBox = Instance.new("TextBox")
debugTextBox.Size = UDim2.new(1, 0, 1, -50)
debugTextBox.BackgroundColor3 = colors.bg
debugTextBox.TextColor3 = colors.text
debugTextBox.TextSize = 12
debugTextBox.Font = Enum.Font.Code
debugTextBox.Text = ""
debugTextBox.ClearTextOnFocus = false
debugTextBox.MultiLine = true
debugTextBox.TextXAlignment = Enum.TextXAlignment.Left
debugTextBox.TextYAlignment = Enum.TextYAlignment.Top
debugTextBox.Parent = debugTab.content

local debugCorner = Instance.new("UICorner")
debugCorner.CornerRadius = UDim.new(0, 8)
debugCorner.Parent = debugTextBox

local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(1, 0, 0, 40)
refreshButton.Position = UDim2.new(0, 0, 1, -40)
refreshButton.BackgroundColor3 = colors.accent
refreshButton.Text = "Refresh Log"
refreshButton.TextColor3 = colors.text
refreshButton.TextSize = 16
refreshButton.Font = Enum.Font.GothamBold
refreshButton.Parent = debugTab.content

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 8)
refreshCorner.Parent = refreshButton

refreshButton.MouseButton1Click:Connect(function()
    debugTextBox.Text = table.concat(debugLog, "\n")
end)

spawn(function()
    while ScreenGui.Parent do
        wait(1)
        if debugTab.content.Visible then
            debugTextBox.Text = table.concat(debugLog, "\n")
        end
    end
end)

-- Control handlers
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    RunService:UnbindFromRenderStep("ZeroHub_Fly")
    RunService:UnbindFromRenderStep("ZeroHub_Noclip")
end)

-- Initialize
switchTab(playerTab)

log("ZeroHub v1.4 loaded!")
log("Based on discovered remotes:")
log("- QueueBlocksRequest")
log("- BlockRequestsRemote")
log("- InstaLoadFunction")
log("- ItemBoughtFromShop")
log("- SaveBoatData")
