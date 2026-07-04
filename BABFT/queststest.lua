-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local IDInput = Instance.new("TextBox")
local LaunchBtn = Instance.new("TextButton")
local LoopBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- Настройка контейнера GUI
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "BABFT_Quest_Spammer"

-- Главная панель
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -110)
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true -- Можно двигать мышкой

-- Заголовок
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "BABFT Quest Tool"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Поле ввода ID
IDInput.Parent = MainFrame
IDInput.Position = UDim2.new(0, 10, 0, 45)
IDInput.Size = UDim2.new(0, 180, 0, 35)
IDInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
IDInput.Text = ""
IDInput.PlaceholderText = "Введите ID (напр. 1)"
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Кнопка одиночного запуска
LaunchBtn.Parent = MainFrame
LaunchBtn.Position = UDim2.new(0, 10, 0, 90)
LaunchBtn.Size = UDim2.new(0, 180, 0, 35)
LaunchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
LaunchBtn.Text = "Запустить квест"
LaunchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Кнопка перебора 1-200
LoopBtn.Parent = MainFrame
LoopBtn.Position = UDim2.new(0, 10, 0, 135)
LoopBtn.Size = UDim2.new(0, 180, 0, 35)
LoopBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
LoopBtn.Text = "Перебор 1 - 200"
LoopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Строка статуса
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 10, 0, 180)
StatusLabel.Size = UDim2.new(0, 180, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Готов к работе"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12

-- Ссылка на удаленное событие игры
local QuestEvent = workspace:WaitForChild("QuestMakerEvent")
local isLooping = false

-- Логика одиночного запуска
LaunchBtn.MouseButton1Click:Connect(function()
    local questId = tonumber(IDInput.Text)
    if questId then
        QuestEvent:FireServer(questId)
        StatusLabel.Text = "Отправлен ID: " .. questId
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "Неверный ID!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Логика перебора от 1 до 200
LoopBtn.MouseButton1Click:Connect(function()
    if isLooping then
        isLooping = false
        LoopBtn.Text = "Перебор 1 - 200"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        StatusLabel.Text = "Перебор остановлен"
        return
    end

    isLooping = true
    LoopBtn.Text = "ОСТАНОВИТЬ"
    LoopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

    task.spawn(function()
        for i = 1, 200 do
            if not isLooping then break end
            
            StatusLabel.Text = "Проверка ID: " .. i
            StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
            
            QuestEvent:FireServer(i)
            task.wait(0.2) -- КД 0.2 секунды
        end
        
        isLooping = false
        LoopBtn.Text = "Перебор 1 - 200"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        StatusLabel.Text = "Цикл завершен"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    end)
end)
