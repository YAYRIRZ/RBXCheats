--[[
    ZeroHub - Advanced Script Hub for Roblox
    Version: 1.3
    Colors: Cyan, Blue, Black
    Features: Player Mods + Infinite Blocks (Advanced Bypass Methods)
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

-- Debug log
local debugLog = {}
local function log(msg)
    table.insert(debugLog, msg)
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
MainFrame.Size = UDim2.new(0, 550, 0, 550)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -275)
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
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 180))
}
titleGradient.Rotation = 90
titleGradient.Parent = TitleBar

-- Logo
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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -150, 1, 0)
Title.Position = UDim2.new(0, 65, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZeroHub v1.3"
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

local playerTab = createTab("Player", "[P]")
local infBlocksTab = createTab("Inf Blocks", "[B]")
local debugTab = createTab("Debug", "[D]")

playerTab.button.MouseButton1Click:Connect(function() switchTab(playerTab) end)
infBlocksTab.button.MouseButton1Click:Connect(function() switchTab(infBlocksTab) end)
debugTab.button.MouseButton1Click:Connect(function() switchTab(debugTab) end)

-- Helper functions
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

-- INF BLOCKS ADVANCED METHODS

-- Method 1: Scan and log all remotes
local function scanRemotes()
    log("Scanning for remotes...")
    local remotes = {}
    
    -- Scan ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remotes, {
                name = obj.Name,
                path = obj:GetFullName(),
                type = obj.ClassName
            })
            log("Found: " .. obj:GetFullName() .. " (" .. obj.ClassName .. ")")
        end
    end
    
    -- Scan workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remotes, {
                name = obj.Name,
                path = obj:GetFullName(),
                type = obj.ClassName
            })
            log("Found: " .. obj:GetFullName() .. " (" .. obj.ClassName .. ")")
        end
    end
    
    log("Total remotes found: " .. #remotes)
    return remotes
end

-- Method 2: Network hook - intercept and modify remote calls
local function setupNetworkHook()
    log("Setting up network hook...")
    
    local success, err = pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            local oldNamecall = mt.__namecall
            
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                
                -- Log all remote calls
                if method == "FireServer" or method == "InvokeServer" then
                    local args = {...}
                    log("Remote call: " .. self:GetFullName() .. "." .. method)
                    
                    -- Try to modify block-related calls
                    if args[1] and type(args[1]) == "string" then
                        local name = tostring(args[1]):lower()
                        if string.find(name, "block") or string.find(name, "place") or string.find(name, "build") then
                            log("Intercepted block call: " .. name)
                            -- Allow the call to proceed
                        end
                    end
                end
                
                return oldNamecall(self, ...)
            end)
            
            log("Network hook installed successfully")
        else
            log("ERROR: Cannot get raw metatable")
        end
    end)
    
    if not success then
        log("ERROR: " .. tostring(err))
    end
end

-- Method 3: Force place block using found remotes
local function forcePlaceBlock()
    log("Attempting to force place blocks...")
    
    local remotes = scanRemotes()
    local placeRemotes = {}
    
    -- Find potential place block remotes
    for _, remote in pairs(remotes) do
        local name = remote.name:lower()
        if string.find(name, "place") or string.find(name, "build") or 
           string.find(name, "spawn") or string.find(name, "create") then
            table.insert(placeRemotes, remote)
            log("Potential place remote: " .. remote.path)
        end
    end
    
    if #placeRemotes == 0 then
        log("ERROR: No place remotes found")
        return
    end
    
    -- Try each remote
    for _, remote in pairs(placeRemotes) do
        log("Trying remote: " .. remote.path)
        
        local obj = ReplicatedStorage:FindFirstChild(remote.name, true)
        if obj then
            pcall(function()
                local pos = rootPart.CFrame * CFrame.new(0, -5, 0)
                
                if obj:IsA("RemoteFunction") then
                    local result = obj:InvokeServer("Wood Block", pos)
                    log("InvokeServer result: " .. tostring(result))
                else
                    obj:FireServer("Wood Block", pos)
                    log("FireServer called")
                end
            end)
        end
    end
end

-- Method 4: Memory manipulation - directly modify game state
local function memoryManipulation()
    log("Attempting memory manipulation...")
    
    pcall(function()
        -- Find player's inventory/data
        local playerData = player:FindFirstChild("PlayerData") or 
                          player:FindFirstChild("Data") or
                          player:FindFirstChild("Stats")
        
        if playerData then
            log("Found player data: " .. playerData:GetFullName())
            
            -- Modify all numeric values related to blocks
            for _, value in pairs(playerData:GetDescendants()) do
                if value:IsA("IntValue") or value:IsA("NumberValue") then
                    local name = value.Name:lower()
                    if string.find(name, "block") or string.find(name, "wood") or 
                       string.find(name, "stone") or string.find(name, "iron") or
                       string.find(name, "gold") or string.find(name, "count") or
                       string.find(name, "amount") or string.find(name, "inventory") then
                        pcall(function()
                            value.Value = 999999999
                            log("Modified: " .. value:GetFullName() .. " = 999999999")
                        end)
                    end
                end
            end
        else
            log("WARNING: Player data not found")
        end
        
        -- Try to find and modify building tools
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if string.find(name, "block") or string.find(name, "build") or string.find(name, "hammer") then
                        log("Found building tool: " .. tool.Name)
                        
                        -- Try to find and modify tool's internal values
                        for _, value in pairs(tool:GetDescendants()) do
                            if value:IsA("IntValue") or value:IsA("NumberValue") then
                                pcall(function()
                                    value.Value = 999999999
                                    log("Modified tool value: " .. value:GetFullName())
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    log("Memory manipulation complete")
end

-- Method 5: Aggressive bypass - hook everything
local function aggressiveBypass()
    log("Starting aggressive bypass...")
    
    -- Hook metatable
    pcall(function()
        local mt = getrawmetatable(game)
        if mt and not mt.__metatable then
            local oldIndex = mt.__index
            local oldNewindex = mt.__newindex
            
            mt.__index = newcclosure(function(self, key)
                if key == "MaxBlocks" or key == "BlockLimit" or key == "maxBlocks" or key == "blockLimit" then
                    return 999999999
                end
                return oldIndex(self, key)
            end)
            
            mt.__newindex = newcclosure(function(self, key, value)
                if key == "MaxBlocks" or key == "BlockLimit" or key == "maxBlocks" or key == "blockLimit" then
                    value = 999999999
                end
                return oldNewindex(self, key, value)
            end)
            
            log("Metatable hooks installed")
        end
    end)
    
    -- Hook all LocalScripts
    pcall(function()
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in pairs(playerGui:GetDescendants()) do
                if gui:IsA("LocalScript") then
                    pcall(function()
                        local env = getfenv(gui)
                        if env then
                            env.MaxBlocks = 999999999
                            env.BlockLimit = 999999999
                            env.maxBlocks = 999999999
                            env.blockLimit = 999999999
                            env.MAX_BLOCKS = 999999999
                            env.BLOCK_LIMIT = 999999999
                            log("Hooked LocalScript: " .. gui:GetFullName())
                        end
                    end)
                end
            end
        end
    end)
    
    -- Modify all player data
    memoryManipulation()
    
    -- Setup network hook
    setupNetworkHook()
    
    log("Aggressive bypass complete")
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
infoLabel.Size = UDim2.new(1, 0, 0, 140)
infoLabel.BackgroundColor3 = colors.button
infoLabel.BorderSizePixel = 0
infoLabel.Text = "[INFO] Advanced Infinite Blocks v1.3\n\nThese methods use advanced bypass techniques.\nRun them in order for best results.\n\n1. Scan Remotes - Find all network calls\n2. Setup Network Hook - Intercept remote calls\n3. Aggressive Bypass - Hook everything (run this first!)\n4. Force Place Block - Try to place blocks\n5. Memory Manipulation - Modify game state"
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

createButton(infBlocksTab.content, "1. Scan Remotes", scanRemotes)
createButton(infBlocksTab.content, "2. Setup Network Hook", setupNetworkHook)
createButton(infBlocksTab.content, "3. Aggressive Bypass (RUN FIRST)", aggressiveBypass)
createButton(infBlocksTab.content, "4. Force Place Block", forcePlaceBlock)
createButton(infBlocksTab.content, "5. Memory Manipulation", memoryManipulation)

local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, 0, 0, 80)
warningLabel.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
warningLabel.BorderSizePixel = 0
warningLabel.Text = "[IMPORTANT]\n1. Run 'Aggressive Bypass' FIRST\n2. Check Debug tab for logs\n3. Buy at least 1 block before trying\n4. If server validates everything, these may not work\n5. Try on private server first"
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

-- Populate Debug Tab
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

-- Auto-refresh debug log every 2 seconds
spawn(function()
    while ScreenGui.Parent do
        wait(2)
        if currentTab == debugTab then
            debugTextBox.Text = table.concat(debugLog, "\n")
        end
    end
end)

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
        MainFrame.Size = UDim2.new(0, 550, 0, 550)
        ContentArea.Visible = true
        TabContainer.Visible = true
        MinimizeButton.Text = "-"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    RunService:UnbindFromRenderStep("ZeroHub_Fly")
    RunService:UnbindFromRenderStep("ZeroHub_Noclip")
end)

-- Initialize
switchTab(playerTab)

log("ZeroHub v1.3 loaded!")
log("Features: Player mods + Advanced Inf Blocks")
log("Check Debug tab for detailed logs")
