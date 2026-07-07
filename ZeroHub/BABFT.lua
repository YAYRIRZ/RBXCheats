--[[
    BABFT Hub - Build A Boat For Treasure Script Hub
    Version: 1.0
    Features: Basic GUI + Essential Hacks
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
    speed = 16,
    jumpPower = 50,
    fly = false,
    noclip = false,
    godMode = false,
    infiniteJump = false,
    autoFarm = false,
    speedBoost = false
}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BABFTHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0, 50, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Title Text
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚢 BABFT Hub"
Title.TextColor3 = Color3.fromRGB(255, 200, 50)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Scroll Frame for buttons
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ScrollFrame

-- Button Creation Function
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.Gotham
    button.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local active = false
    
    button.MouseButton1Click:Connect(function()
        active = not active
        if active then
            button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            button.Text = text .. " [ON]"
        else
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            button.Text = text
        end
        callback(active)
    end)
    
    return button
end

-- Functions
local function toggleFly(enabled)
    settings.fly = enabled
    if enabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        RunService:BindToRenderStep("FlyControl", 1, function()
            if not settings.fly then return end
            local moveDirection = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            bodyVelocity.Velocity = moveDirection * settings.speed
        end)
    else
        local flyVelocity = rootPart:FindFirstChild("FlyVelocity")
        if flyVelocity then flyVelocity:Destroy() end
        RunService:UnbindFromRenderStep("FlyControl")
    end
end

local function toggleNoclip(enabled)
    settings.noclip = enabled
    if enabled then
        RunService:BindToRenderStep("Noclip", 1, function()
            if not settings.noclip then return end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("Noclip")
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

local function toggleSpeedBoost(enabled)
    settings.speedBoost = enabled
    humanoid.WalkSpeed = enabled and 50 or 16
end

-- Create Buttons
createButton("🕊️ Fly (WASD + Space/Shift)", toggleFly)
createButton("👻 Noclip", toggleNoclip)
createButton("💚 God Mode", toggleGodMode)
createButton("🦘 Infinite Jump", toggleInfiniteJump)
createButton("⚡ Speed Boost", toggleSpeedBoost)

-- Separator
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, 0, 0, 2)
separator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
separator.BorderSizePixel = 0
separator.Parent = ScrollFrame

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 60)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "BABFT Hub v1.0\nMade with ❤️\nDrag window to move"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Parent = ScrollFrame

-- Update CanvasSize
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
end)

print("🚢 BABFT Hub loaded successfully!")
