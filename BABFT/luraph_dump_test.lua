--[[
    ButterHub Final Dumper - GUI + Hooks
    Запусти ПЕРЕД ButterHub скриптом!
]]

-- Storage
local hooks = {
    strings = {},
    loads = {},
    scripts = {}
}

-- Hook loadstring ПЕРЕД запуском ButterHub
local orig_loadstring = loadstring
loadstring = function(code, chunkname)
    table.insert(hooks.loads, {
        code = code,
        chunkname = chunkname or "unknown",
        time = tick()
    })
    return orig_loadstring(code, chunkname)
end

-- Hook load
if load then
    local orig_load = load
    load = function(code, chunkname, env)
        table.insert(hooks.loads, {
            code = code,
            chunkname = chunkname or "unknown",
            time = tick()
        })
        return orig_load(code, chunkname, env)
    end
end

-- Hook string.char
local orig_char = string.char
string.char = function(...)
    local result = orig_char(...)
    if #result > 2 then
        table.insert(hooks.strings, result)
    end
    return result
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ButterHubDumper"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 400)
frame.Position = UDim2.new(0.5, -250, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "🧈 ButterHub Dumper"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Hooks installed ✓"
statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
statusLabel.TextSize = 16
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -20, 0, 60)
statsLabel.Position = UDim2.new(0, 10, 0, 90)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "Strings: 0\nLoads: 0\nScripts: 0"
statsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statsLabel.TextSize = 14
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.Parent = frame

local outputBox = Instance.new("ScrollingFrame")
outputBox.Size = UDim2.new(1, -20, 0, 200)
outputBox.Position = UDim2.new(0, 10, 0, 160)
outputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
outputBox.BorderSizePixel = 0
outputBox.ScrollBarThickness = 6
outputBox.Parent = frame

local outputLayout = Instance.new("UIListLayout")
outputLayout.Parent = outputBox

local function addLog(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = outputBox
    outputBox.CanvasSize = UDim2.new(0, 0, 0, #outputBox:GetChildren() * 20)
    outputBox.CanvasPosition = Vector2.new(0, outputBox.CanvasSize.Y.Offset)
end

local dumpButton = Instance.new("TextButton")
dumpButton.Size = UDim2.new(0.48, 0, 0, 40)
dumpButton.Position = UDim2.new(0.02, 0, 0, 370)
dumpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
dumpButton.Text = "DUMP NOW"
dumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dumpButton.TextSize = 16
dumpButton.Font = Enum.Font.GothamBold
dumpButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.48, 0, 0, 40)
closeButton.Position = UDim2.new(0.5, 0, 0, 370)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeButton.Text = "CLOSE"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = frame

-- Update stats
spawn(function()
    while screenGui.Parent do
        statsLabel.Text = string.format(
            "Strings: %d\nLoads: %d\nScripts: %d",
            #hooks.strings,
            #hooks.loads,
            #hooks.scripts
        )
        wait(0.5)
    end
end)

-- Dump function
local function dumpAll()
    statusLabel.Text = "Status: Dumping..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    addLog("Starting dump...", Color3.fromRGB(255, 200, 50))
    
    local output = "=== BUTTERHUB DUMP ===\n"
    output = output .. "Date: " .. os.date() .. "\n\n"
    
    -- Add loads
    output = output .. "=== DECODED LOADS (" .. #hooks.loads .. ") ===\n\n"
    for i, load_data in ipairs(hooks.loads) do
        output = output .. "--- Load " .. i .. " [" .. load_data.chunkname .. "] ---\n"
        output = output .. load_data.code .. "\n\n"
        addLog("[LOAD " .. i .. "] " .. #load_data.code .. " bytes", Color3.fromRGB(100, 200, 255))
    end
    
    -- Add unique strings
    output = output .. "\n=== STRINGS (" .. #hooks.strings .. ") ===\n\n"
    local unique_strings = {}
    for _, s in ipairs(hooks.strings) do
        if not unique_strings[s] and #s > 3 then
            unique_strings[s] = true
            output = output .. s .. "\n"
        end
    end
    
    -- Save
    local saved = false
    
    if writefile then
        pcall(function()
            writefile("ButterHub_decoded.lua", output)
            addLog("[SAVED] ButterHub_decoded.lua", Color3.fromRGB(50, 255, 50))
            saved = true
        end)
    end
    
    if not saved and setclipboard then
        pcall(function()
            setclipboard(output)
            addLog("[SAVED] Clipboard", Color3.fromRGB(50, 255, 50))
            saved = true
        end)
    end
    
    if saved then
        statusLabel.Text = "Status: Complete! ✓"
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        statusLabel.Text = "Status: Failed ✗"
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
    
    addLog("=== DUMP COMPLETE ===", Color3.fromRGB(50, 255, 50))
end

-- Button handlers
dumpButton.MouseButton1Click:Connect(dumpAll)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

addLog("Hooks installed!", Color3.fromRGB(50, 255, 50))
addLog("Now run ButterHub script...", Color3.fromRGB(255, 200, 50))
addLog("Click DUMP NOW after ButterHub loads", Color3.fromRGB(200, 200, 200))
