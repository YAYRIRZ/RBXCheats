--[[
    ZeroHub v2.8 - BABFT AutoFarm + Disable 3D Render
    Simple version with render disable feature
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserSettings = UserSettings()
local RenderSettings = UserSettings():GetService("UserGameSettings")

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
    autoFarm = false,
    teleportDelay = 2,
    disableRender = false,
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
MainFrame.Size = UDim2.new(0, 650, 0, 700)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -350)
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
Title.Text = "ZeroHub v2.8 - BABFT AutoFarm + Render Control"
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
local farmTab = createTab("AutoFarm")
local renderTab = createTab("Render")
local debugTab = createTab("Debug")

playerTab.button.MouseButton1Click:Connect(function() switchTab(playerTab) end)
farmTab.button.MouseButton1Click:Connect(function() switchTab(farmTab) end)
renderTab.button.MouseButton1Click:Connect(function() switchTab(renderTab) end)
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

-- RENDER FUNCTIONS
local originalSettings = {}

local function saveOriginalSettings()
    originalSettings.SavedQualityLevel = RenderSettings.SavedQualityLevel
    originalSettings.Fullscreen = RenderSettings.Fullscreen
    originalSettings.GraphicsQualityLevel = RenderSettings.GraphicsQualityLevel
    log("Saved original render settings")
end

local function restoreOriginalSettings()
    pcall(function()
        RenderSettings.SavedQualityLevel = originalSettings.SavedQualityLevel or 10
        RenderSettings.Fullscreen = originalSettings.Fullscreen or false
        RenderSettings.GraphicsQualityLevel = originalSettings.GraphicsQualityLevel or 10
        log("Restored original render settings")
    end)
end

local function disable3DRender(enabled)
    settings.disableRender = enabled
    
    if enabled then
        log("Disabling 3D render for better performance...")
        saveOriginalSettings()
        
        pcall(function()
            -- Set lowest quality
            RenderSettings.SavedQualityLevel = 1
            RenderSettings.GraphicsQualityLevel = 1
            
            -- Disable fullscreen
            RenderSettings.Fullscreen = false
            
            -- Disable shadows via Lighting
            Lighting.GlobalShadows = false
            Lighting.ShadowColor = Color3.new(0, 0, 0)
            
            -- Reduce lighting quality
            Lighting.Brightness = 0.5
            Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 50)
            
            -- Disable post-processing effects
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("PostEffect") then
                    effect.Enabled = false
                end
            end
            
            -- Set camera to very low render distance
            local camera = workspace.CurrentCamera
            if camera then
                camera.NearPlaneZ = 0.1
                camera.FarPlaneZ = 50
            end
            
            -- Make all parts transparent except player
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(character) then
                    obj.Transparency = 0.9
                end
            end
        end)
        
        log("3D render disabled - maximum performance!")
    else
        log("Re-enabling 3D render...")
        restoreOriginalSettings()
        
        pcall(function()
            -- Re-enable shadows
            Lighting.GlobalShadows = true
            
            -- Restore lighting
            Lighting.Brightness = 1
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            
            -- Re-enable post-processing
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("PostEffect") then
                    effect.Enabled = true
                end
            end
            
            -- Restore camera
            local camera = workspace.CurrentCamera
            if camera then
                camera.NearPlaneZ = 0.1
                camera.FarPlaneZ = 1000
            end
            
            -- Restore part transparency
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(character) then
                    obj.Transparency = 0
                end
            end
        end)
        
        log("3D render re-enabled")
    end
end

local function setGraphicsQuality(quality)
    pcall(function()
        RenderSettings.SavedQualityLevel = quality
        RenderSettings.GraphicsQualityLevel = quality
        log("Graphics quality set to: " .. quality)
    end)
end

-- AUTOFARM FUNCTIONS
local originalGravity = workspace.Gravity

local function isAlive(char)
    return char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
end

local function applyGodMode(char)
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.MaxHealth = math.huge
        char.Humanoid.Health = math.huge
    end
end

local function farmLoop()
    log("Starting autofarm loop...")
    log("Teleport delay: " .. settings.teleportDelay .. " seconds")
    
    local totalRuns = 0
    local startTime = tick()
    
    while settings.autoFarm do
        totalRuns = totalRuns + 1
        log("Starting run #" .. totalRuns)
        
        -- Wait for character to spawn
        repeat
            task.wait(0.1)
        until not settings.autoFarm or (player.Character and isAlive(player.Character))
        
        if not settings.autoFarm then break end
        
        local char = player.Character
        applyGodMode(char)
        
        -- Find BoatStages
        local boatStages = workspace:FindFirstChild("BoatStages")
        if not boatStages then
            log("ERROR: BoatStages folder not found")
            task.wait(2)
        else
            local normalStages = boatStages:FindFirstChild("NormalStages")
            if not normalStages then
                log("ERROR: NormalStages folder not found")
                task.wait(2)
            else
                log("Found BoatStages/NormalStages")
                
                -- Go through all stages
                for i = 1, 10 do
                    if not settings.autoFarm then break end
                    
                    local stageName = "CaveStage" .. i
                    local stage = normalStages:FindFirstChild(stageName)
                    
                    if not stage then
                        log("WARNING: " .. stageName .. " not found")
                    else
                        local darknessPart = stage:FindFirstChild("DarknessPart")
                        if not darknessPart then
                            log("WARNING: DarknessPart not found in " .. stageName)
                        else
                            -- Check if character is still alive
                            if not isAlive(char) then
                                log("Character died, waiting for respawn...")
                                repeat
                                    task.wait(0.1)
                                until not settings.autoFarm or isAlive(player.Character)
                                
                                if not settings.autoFarm then break end
                                char = player.Character
                                applyGodMode(char)
                            end
                            
                            -- Teleport to stage
                            log("Teleporting to " .. stageName)
                            char.HumanoidRootPart.CFrame = darknessPart.CFrame
                            
                            -- Wait for teleport delay
                            task.wait(settings.teleportDelay)
                        end
                    end
                end
                
                if settings.autoFarm then
                    -- Go to the end (GoldenChest)
                    log("Teleporting to TheEnd (GoldenChest)...")
                    local theEnd = normalStages:FindFirstChild("TheEnd")
                    if theEnd then
                        local goldenChest = theEnd:FindFirstChild("GoldenChest")
                        if goldenChest then
                            local trigger = goldenChest:FindFirstChild("Trigger")
                            if trigger then
                                if isAlive(char) then
                                    char.HumanoidRootPart.CFrame = trigger.CFrame
                                    
                                    -- Wait until day time changes (indicates chest claimed)
                                    local startClockTime = Lighting.ClockTime
                                    local waitStart = tick()
                                    
                                    repeat
                                        task.wait(0.1)
                                        if not settings.autoFarm or not isAlive(player.Character) then break end
                                    until Lighting.ClockTime ~= startClockTime or (tick() - waitStart) > 10
                                    
                                    log("GoldenChest trigger activated")
                                end
                            else
                                log("WARNING: Trigger not found in GoldenChest")
                            end
                        else
                            log("WARNING: GoldenChest not found in TheEnd")
                        end
                    else
                        log("WARNING: TheEnd not found in NormalStages")
                    end
                end
            end
        end
        
        if not settings.autoFarm then break end
        
        -- Wait for respawn
        log("Waiting for respawn...")
        local respawned = false
        local connection
        connection = player.CharacterAdded:Connect(function()
            respawned = true
            connection:Disconnect()
        end)
        
        repeat
            task.wait(0.1)
        until not settings.autoFarm or respawned
        
        if connection.Connected then
            connection:Disconnect()
        end
        
        -- Wait between runs
        task.wait(2)
        
        local elapsedTime = tick() - startTime
        local runsPerHour = (totalRuns / elapsedTime) * 3600
        
        log("Run #" .. totalRuns .. " complete - Runs/hour: " .. string.format("%.1f", runsPerHour))
    end
    
    log("Autofarm stopped - Total runs: " .. totalRuns)
end

local function toggleAutoFarm(enabled)
    settings.autoFarm = enabled
    if enabled then
        log("AutoFarm enabled - starting farm loop")
        task.spawn(farmLoop)
    else
        log("AutoFarm disabled - stopping")
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

-- AutoFarm tab
local farmInfoLabel = Instance.new("TextLabel")
farmInfoLabel.Size = UDim2.new(1, 0, 0, 140)
farmInfoLabel.BackgroundColor3 = colors.button
farmInfoLabel.Text = "[INFO] Simple AutoFarm\n\nHOW IT WORKS:\n1. Teleports to CaveStage1-10 DarknessPart\n2. Teleports to TheEnd/GoldenChest/Trigger\n3. Waits for chest to be claimed\n4. Respawns and repeats\n\nTIP: Enable 'Disable 3D Render' in Render tab for better performance!"
farmInfoLabel.TextColor3 = colors.textDim
farmInfoLabel.TextSize = 12
farmInfoLabel.Font = Enum.Font.Gotham
farmInfoLabel.TextWrapped = true
farmInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
farmInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
farmInfoLabel.Parent = farmTab.content

local farmInfoCorner = Instance.new("UICorner")
farmInfoCorner.CornerRadius = UDim.new(0, 8)
farmInfoCorner.Parent = farmInfoLabel

createSlider(farmTab.content, "Teleport Delay (seconds)", 1, 10, 2, function(v)
    settings.teleportDelay = v
    log("Teleport delay set to: " .. v .. " seconds")
end)

createToggle(farmTab.content, "START AUTOFARM", toggleAutoFarm)

-- Render tab
local renderInfoLabel = Instance.new("TextLabel")
renderInfoLabel.Size = UDim2.new(1, 0, 0, 160)
renderInfoLabel.BackgroundColor3 = colors.button
renderInfoLabel.Text = "[INFO] Render Control\n\nDISABLE 3D RENDER:\n- Sets graphics to lowest quality\n- Disables shadows\n- Reduces lighting quality\n- Makes parts transparent\n- Reduces render distance\n- MASSIVE FPS BOOST!\n\nUse this while autofarming for better performance!"
renderInfoLabel.TextColor3 = colors.textDim
renderInfoLabel.TextSize = 12
renderInfoLabel.Font = Enum.Font.Gotham
renderInfoLabel.TextWrapped = true
renderInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
renderInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
renderInfoLabel.Parent = renderTab.content

local renderInfoCorner = Instance.new("UICorner")
renderInfoCorner.CornerRadius = UDim.new(0, 8)
renderInfoCorner.Parent = renderInfoLabel

createToggle(renderTab.content, "Disable 3D Render (FPS Boost)", disable3DRender)

createSlider(renderTab.content, "Graphics Quality", 1, 21, 10, function(v)
    setGraphicsQuality(v)
end)

createButton(renderTab.content, "Set Lowest Quality", function()
    setGraphicsQuality(1)
end)

createButton(renderTab.content, "Set Highest Quality", function()
    setGraphicsQuality(21)
end)

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
    settings.autoFarm = false
    
    -- Restore render settings if they were changed
    if settings.disableRender then
        restoreOriginalSettings()
    end
end)

-- Initialize
switchTab(playerTab)

log("ZeroHub v2.8 loaded!")
log("Features: AutoFarm + Disable 3D Render")
log("TIP: Disable 3D Render for massive FPS boost while farming!")
