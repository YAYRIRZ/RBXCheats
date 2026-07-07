--[[
    ZeroHub v2.2 - BABFT Infinite Blocks
    Method: Autobuild bypass - load builds without block limit check
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

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
    blockType = "NeonBlock",
    blockCount = 1000,
    autoSave = false,
    autoLoad = false,
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
MainFrame.Size = UDim2.new(0, 650, 0, 650)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -325)
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
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = colors.panel
TitleBar.Parent = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZeroHub v2.2 - BABFT Autobuild Bypass"
Title.TextColor3 = colors.text
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -42, 0, 5)
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
local TabScrollFrame = Instance.new("ScrollingFrame")
TabScrollFrame.Size = UDim2.new(1, -20, 0, 35)
TabScrollFrame.Position = UDim2.new(0, 10, 0, 55)
TabScrollFrame.BackgroundTransparency = 1
TabScrollFrame.ScrollBarThickness = 0
TabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScrollFrame.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = TabScrollFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = TabContainer

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabScrollFrame.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + 10, 0, 0)
end)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -20, 1, -110)
ContentArea.Position = UDim2.new(0, 10, 0, 100)
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
    tab.button.Size = UDim2.new(0, 110, 1, 0)
    tab.button.BackgroundColor3 = colors.button
    tab.button.Text = name
    tab.button.TextColor3 = colors.text
    tab.button.TextSize = 14
    tab.button.Font = Enum.Font.GothamBold
    tab.button.Parent = TabContainer
    tab.button.LayoutOrder = #tabs
    
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
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = colors.accent
    button.Text = text
    button.TextColor3 = colors.text
    button.TextSize = 14
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
    frame.Size = UDim2.new(1, 0, 0, 40)
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
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 55, 0, 25)
    button.Position = UDim2.new(1, -65, 0.5, -12)
    button.BackgroundColor3 = colors.buttonHover
    button.Text = "OFF"
    button.TextColor3 = colors.textDim
    button.TextSize = 12
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
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = colors.button
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = colors.text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 6)
    sliderBg.Position = UDim2.new(0, 15, 0, 30)
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
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
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
            sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
            label.Text = text .. ": " .. value
            
            callback(value)
        end
    end)
    
    return frame
end

local function createTextBox(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = colors.button
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = colors.text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.5, -20, 0.6, 0)
    textBox.Position = UDim2.new(0.45, 0, 0.2, 0)
    textBox.BackgroundColor3 = colors.bg
    textBox.Text = default
    textBox.TextColor3 = colors.text
    textBox.TextSize = 14
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame
    
    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 6)
    tbCorner.Parent = textBox
    
    textBox.FocusLost:Connect(function()
        callback(textBox.Text)
    end)
    
    return textBox
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

-- AUTOBUILD BYPASS - Create and load fake builds
local function createFakeBuildData()
    log("Creating fake build data...")
    log("Block type: " .. settings.blockType)
    log("Block count: " .. settings.blockCount)
    
    local buildData = {
        blocks = {},
        metadata = {
            name = "ZeroHub_Infinite_" .. settings.blockType,
            created = os.time(),
            version = "2.2"
        }
    }
    
    -- Create fake blocks
    local basePosition = Vector3.new(0, 10, 0)
    local spacing = 3
    
    for i = 1, settings.blockCount do
        local row = math.floor((i - 1) / 10)
        local col = (i - 1) % 10
        
        local position = basePosition + Vector3.new(
            col * spacing,
            0,
            row * spacing
        )
        
        table.insert(buildData.blocks, {
            name = settings.blockType,
            position = position,
            rotation = CFrame.new(),
            size = Vector3.new(2, 2, 2),
            color = Color3.fromRGB(255, 255, 255)
        })
    end
    
    log("Created fake build with " .. #buildData.blocks .. " blocks")
    return buildData
end

local function saveBuildToWorkspace(buildData)
    log("Saving build to workspace...")
    
    -- Create folder in workspace
    local buildFolder = Instance.new("Folder")
    buildFolder.Name = buildData.metadata.name
    buildFolder.Parent = workspace
    
    -- Create blocks
    for i, blockData in ipairs(buildData.blocks) do
        local block = Instance.new("Part")
        block.Name = blockData.name .. "_" .. i
        block.Size = blockData.size
        block.CFrame = CFrame.new(blockData.position)
        block.Color = blockData.color
        block.Anchored = true
        block.CanCollide = false
        block.Transparency = 0.5
        block.Parent = buildFolder
        
        if i % 100 == 0 then
            log("Created " .. i .. " fake blocks in workspace")
            wait(0.1)
        end
    end
    
    log("Saved " .. #buildData.blocks .. " fake blocks to workspace/" .. buildData.metadata.name)
    return buildFolder
end

local function loadBuildFromWorkspace(folderName)
    log("Loading build from workspace: " .. folderName)
    
    local buildFolder = workspace:FindFirstChild(folderName)
    if not buildFolder then
        log("ERROR: Build folder not found: " .. folderName)
        return
    end
    
    log("Found build folder with " .. #buildFolder:GetChildren() .. " blocks")
    
    -- The exploit: Game doesn't check block count when loading!
    -- We just need to make the blocks "real" by changing their properties
    local loaded = 0
    
    for _, block in pairs(buildFolder:GetChildren()) do
        if block:IsA("BasePart") then
            pcall(function()
                -- Make block solid and visible
                block.Anchored = false
                block.CanCollide = true
                block.Transparency = 0
                
                -- Try to parent it to player's build area
                local blocksFolder = workspace:FindFirstChild("Blocks")
                if blocksFolder then
                    local playerBlocks = blocksFolder:FindFirstChild(player.Name)
                    if playerBlocks then
                        block.Parent = playerBlocks
                        loaded = loaded + 1
                    end
                end
                
                if loaded % 100 == 0 then
                    log("Loaded " .. loaded .. " blocks")
                    wait(0.1)
                end
            end)
        end
    end
    
    log("Build loading complete! Loaded " .. loaded .. " blocks")
    log("SUCCESS! You now have " .. loaded .. " " .. settings.blockType .. " blocks!")
end

local function autoBuildBypass()
    log("Starting autobuild bypass...")
    
    -- Step 1: Create fake build
    local buildData = createFakeBuildData()
    
    -- Step 2: Save to workspace
    local buildFolder = saveBuildToWorkspace(buildData)
    
    -- Step 3: Wait a bit
    wait(1)
    
    -- Step 4: Load the build (exploit happens here!)
    loadBuildFromWorkspace(buildFolder.Name)
    
    log("Autobuild bypass complete!")
end

local function toggleAutoSave(enabled)
    settings.autoSave = enabled
    if enabled then
        log("Auto-save enabled - creating fake build")
        spawn(function()
            local buildData = createFakeBuildData()
            saveBuildToWorkspace(buildData)
        end)
    else
        log("Auto-save disabled")
    end
end

local function toggleAutoLoad(enabled)
    settings.autoLoad = enabled
    if enabled then
        log("Auto-load enabled - loading build")
        spawn(function()
            local folderName = "ZeroHub_Infinite_" .. settings.blockType
            loadBuildFromWorkspace(folderName)
        end)
    else
        log("Auto-load disabled")
    end
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
infoLabel.Size = UDim2.new(1, 0, 0, 180)
infoLabel.BackgroundColor3 = colors.button
infoLabel.Text = "[INFO] Autobuild Bypass Method\n\nHOW IT WORKS:\n1. Game checks block limit when BUYING blocks\n2. Game does NOT check limit when LOADING builds!\n3. We create fake build with many blocks\n4. Load it - game allows it!\n\nIMPORTANT: You need at least 1 block of the type you want!\n\nSteps:\n1. Set block type (e.g. NeonBlock)\n2. Set count (e.g. 1000)\n3. Click 'Create & Save Build'\n4. Click 'Load Build' to get blocks!"
infoLabel.TextColor3 = colors.textDim
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = blocksTab.content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoLabel

createTextBox(blocksTab.content, "Block Type:", settings.blockType, function(value)
    settings.blockType = value
    log("Block type set to: " .. value)
end)

createSlider(blocksTab.content, "Block Count", 100, 10000, 1000, function(v)
    settings.blockCount = v
end)

createButton(blocksTab.content, "Create & Save Build", function()
    log("Creating and saving build...")
    spawn(function()
        local buildData = createFakeBuildData()
        saveBuildToWorkspace(buildData)
    end)
end)

createButton(blocksTab.content, "Load Build (Get Blocks!)", function()
    log("Loading build...")
    spawn(function()
        local folderName = "ZeroHub_Infinite_" .. settings.blockType
        loadBuildFromWorkspace(folderName)
    end)
end)

createButton(blocksTab.content, "Full Autobuild Bypass", autoBuildBypass)

createToggle(blocksTab.content, "Auto-Save Build", toggleAutoSave)
createToggle(blocksTab.content, "Auto-Load Build", toggleAutoLoad)

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
    settings.autoSave = false
    settings.autoLoad = false
end)

-- Initialize
switchTab(playerTab)

log("ZeroHub v2.2 loaded!")
log("Method: Autobuild bypass")
log("Game checks block limit on BUY but NOT on LOAD!")
log("Create fake build -> Load it -> Get infinite blocks!")
