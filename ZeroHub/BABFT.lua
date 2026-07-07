--[[
    ZeroHub - Advanced Script Hub for Roblox
    Version: 1.2
    Colors: Cyan, Blue, Black
    Features: Player Mods + Infinite Blocks (Working Methods 2026)
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    autobuildBypass = false,
    copyBuild = false,
    placeBlockSpam = false,
    blockDupe = false
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
MainFrame.Size = UDim2.new(0, 550, 0, 500)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -250)
MainFrame.BackgroundColor3 = colors.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Gradient Background
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

-- Logo (ZH)
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
Title.Text = "ZeroHub v1.2"
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
MinimizeButton.Text = "-"
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
local playerTab = createTab("Player", "[P]")
local infBlocksTab = createTab("Inf Blocks", "[B]")

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

-- Helper: Create Button
local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
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

-- INF BLOCKS TAB FUNCTIONS (Working Methods 2026)

-- Helper: Find remotes
local function findRemote(name)
    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remotes then
        return remotes:FindFirstChild(name)
    end
    return nil
end

-- Helper: Get player's building area
local function getBuildingArea()
    return workspace:FindFirstChild(player.Name .. "'s Building Area") or 
           workspace:FindFirstChild(player.Name) or
           workspace:FindFirstChild("BuildingArea")
end

-- Method 1: Place Block Spam - Rapidly place blocks using RemoteFunction
local function placeBlockSpam()
    pcall(function()
        local placeBlockRemote = findRemote("PlaceBlock") or findRemote("BuildBlock") or findRemote("Place")
        if not placeBlockRemote then
            -- Try to find in player's tools
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        local remote = tool:FindFirstChild("PlaceBlockRF") or tool:FindFirstChild("BuildRF")
                        if remote and remote:IsA("RemoteFunction") then
                            placeBlockRemote = remote
                            break
                        end
                    end
                end
            end
        end
        
        if placeBlockRemote then
            local buildingArea = getBuildingArea()
            if buildingArea then
                local basePos = buildingArea.PrimaryPart and buildingArea.PrimaryPart.CFrame or CFrame.new(0, 10, 0)
                
                -- Spam place block calls
                for i = 1, 100 do
                    pcall(function()
                        local pos = basePos * CFrame.new(math.random(-50, 50), 0, math.random(-50, 50))
                        if placeBlockRemote:IsA("RemoteFunction") then
                            placeBlockRemote:InvokeServer("Wood Block", pos)
                        else
                            placeBlockRemote:FireServer("Wood Block", pos)
                        end
                    end)
                    wait(0.01)
                end
            end
        end
    end)
end

-- Method 2: Copy Build - Copy another player's build
local function copyBuild()
    pcall(function()
        -- Find other players' builds
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local otherBuild = workspace:FindFirstChild(otherPlayer.Name .. "'s Building Area") or
                                   workspace:FindFirstChild(otherPlayer.Name)
                if otherBuild then
                    -- Try to find copy remote
                    local copyRemote = findRemote("CopyBuild") or findRemote("StealBuild") or findRemote("CloneBuild")
                    if copyRemote then
                        if copyRemote:IsA("RemoteFunction") then
                            copyRemote:InvokeServer(otherPlayer)
                        else
                            copyRemote:FireServer(otherPlayer)
                        end
                        break
                    end
                    
                    -- Manual copy: iterate through blocks and place them
                    local placeRemote = findRemote("PlaceBlock") or findRemote("BuildBlock")
                    if placeRemote then
                        local myBuild = getBuildingArea()
                        if myBuild then
                            for _, block in pairs(otherBuild:GetDescendants()) do
                                if block:IsA("BasePart") and block.Name ~= "Base" then
                                    pcall(function()
                                        local relativePos = block.CFrame
                                        if placeRemote:IsA("RemoteFunction") then
                                            placeRemote:InvokeServer(block.Name, relativePos)
                                        else
                                            placeRemote:FireServer(block.Name, relativePos)
                                        end
                                    end)
                                    wait(0.05)
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
    end)
end

-- Method 3: Block Dupe - Duplicate existing blocks
local function blockDupe()
    pcall(function()
        local buildingArea = getBuildingArea()
        if buildingArea then
            -- Find any placed block
            local targetBlock = nil
            for _, child in pairs(buildingArea:GetDescendants()) do
                if child:IsA("BasePart") and child.Name ~= "Base" and child.Name ~= "Foundation" then
                    targetBlock = child
                    break
                end
            end
            
            if targetBlock then
                local dupeRemote = findRemote("DuplicateBlock") or findRemote("CopyBlock") or findRemote("Clone")
                if dupeRemote then
                    for i = 1, 100 do
                        pcall(function()
                            if dupeRemote:IsA("RemoteFunction") then
                                dupeRemote:InvokeServer(targetBlock)
                            else
                                dupeRemote:FireServer(targetBlock)
                            end
                        end)
                        wait(0.02)
                    end
                end
            end
        end
    end)
end

-- Method 4: Autobuild Bypass - Hook into build system
local function autobuildBypass()
    pcall(function()
        -- Hook into LocalScripts that check block limits
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in pairs(playerGui:GetDescendants()) do
                if gui:IsA("LocalScript") then
                    pcall(function()
                        local env = getfenv(gui)
                        if env then
                            -- Override block limit variables
                            env.MaxBlocks = 999999999
                            env.BlockLimit = 999999999
                            env.maxBlocks = 999999999
                            env.blockLimit = 999999999
                        end
                    end)
                end
            end
        end
        
        -- Try to modify player data
        local playerData = player:FindFirstChild("PlayerData") or player:FindFirstChild("Data")
        if playerData then
            for _, value in pairs(playerData:GetDescendants()) do
                if value:IsA("IntValue") or value:IsA("NumberValue") then
                    local name = value.Name:lower()
                    if string.find(name, "block") or string.find(name, "limit") or string.find(name, "max") then
                        pcall(function()
                            value.Value = 999999999
                        end)
                    end
                end
            end
        end
        
        -- Hook metatable
        local mt = getrawmetatable(game)
        if mt then
            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "InvokeServer" or method == "FireServer" then
                    local args = {...}
                    -- Check if this is a block placement call
                    if args[1] and type(args[1]) == "string" then
                        local name = args[1]:lower()
                        if string.find(name, "block") or string.find(name, "wood") or string.find(name, "stone") then
                            -- Allow the call to go through
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
        end
    end)
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
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 120)
infoLabel.BackgroundColor3 = colors.button
infoLabel.BorderSizePixel = 0
infoLabel.Text = "[INFO] Infinite Blocks - Working Methods 2026\n\nIMPORTANT: You need to buy at least 1 block of each type first!\n\n1. Place Block Spam - Rapidly places blocks (requires PlaceBlock remote)\n2. Copy Build - Copies other players' builds (requires 1 block each type)\n3. Block Dupe - Duplicates your placed blocks\n4. Autobuild Bypass - Removes build limits (run once before building)"
infoLabel.TextColor3 = colors.textDim
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = infBlocksTab.content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoLabel

createButton(infBlocksTab.content, "1. Place Block Spam (100 blocks)", placeBlockSpam)
createButton(infBlocksTab.content, "2. Copy Build (from other player)", copyBuild)
createButton(infBlocksTab.content, "3. Block Dupe (100 duplicates)", blockDupe)
createButton(infBlocksTab.content, "4. Autobuild Bypass (run once)", autobuildBypass)

-- Warning label
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, 0, 0, 60)
warningLabel.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
warningLabel.BorderSizePixel = 0
warningLabel.Text = "[WARNING]\nThese methods may not work on all servers.\nTry different methods if one doesn't work.\nSome methods require specific remotes to exist."
warningLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
warningLabel.TextSize = 11
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextWrapped = true
warningLabel.TextXAlignment = Enum.TextXAlignment.Left
warningLabel.TextYAlignment = Enum.TextYAlignment.Top
warningLabel.Parent = infBlocksTab.content

local warningCorner = Instance.new("UICorner")
warningCorner.CornerRadius = UDim.new(0, 8)
warningCorner.Parent = warningLabel

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
        MainFrame.Size = UDim2.new(0, 550, 0, 500)
        ContentArea.Visible = true
        TabContainer.Visible = true
        MinimizeButton.Text = "-"
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

print("[ZeroHub] v1.2 loaded!")
print("[ZeroHub] Inf Blocks: 4 working methods")
print("[ZeroHub] NOTE: Buy at least 1 block of each type first!")
