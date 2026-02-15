-- Легальный скрипт для образовательных целей
-- ESP + Speed + Silent Aim + Сворачивание окна (RSHIFT)
-- Расширяемое меню

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Переменные для Speed
local speedEnabled = false
local speedMultiplier = 1.0
local baseWalkSpeed = 16
local function getWalkSpeed()
    return baseWalkSpeed * speedMultiplier
end

-- Переменные для Silent Aim
local silentAimEnabled = false
local silentAimTarget = nil
local aimFOV = 90
local aimVisibleCheck = true
local aimSmoothness = 0.5

-- Переменные для сворачивания окна
local windowMinimized = false
local windowMinimizedSize = UDim2.new(0, 300, 0, 40) -- Только заголовок
local windowFullSize = UDim2.new(0, 350, 0, 600)

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_Speed_Aim"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основное меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = windowFullSize
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true -- Важно для сворачивания
MainFrame.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.BackgroundTransparency = 0.2
Title.BorderSizePixel = 0
Title.Text = "ESP + Speed + Silent Aim"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Кнопка сворачивания/разворачивания
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевый
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 24
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = Title

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)
MinimizeCorner.Parent = MinimizeButton

-- Функция сворачивания/разворачивания
local function toggleMinimize()
    windowMinimized = not windowMinimized
    
    -- Анимация сворачивания
    local targetSize = windowMinimized and windowMinimizedSize or windowFullSize
    
    -- Скрываем/показываем контейнер с элементами
    Container.Visible = not windowMinimized
    ResizeFrame.Visible = not windowMinimized
    
    -- Меняем текст кнопки
    MinimizeButton.Text = windowMinimized and "□" or "−"
    
    -- Плавное изменение размера
    local tweenInfo = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = targetSize})
    sizeTween:Play()
end

MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Бинд на RSHIFT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMinimize()
    end
end)

-- Рамка для изменения размера
local ResizeFrame = Instance.new("Frame")
ResizeFrame.Size = UDim2.new(0, 20, 0, 20)
ResizeFrame.Position = UDim2.new(1, -20, 1, -20)
ResizeFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ResizeFrame.BackgroundTransparency = 0.5
ResizeFrame.BorderSizePixel = 0
ResizeFrame.Parent = MainFrame

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 4)
ResizeCorner.Parent = ResizeFrame

local Line1 = Instance.new("Frame")
Line1.Size = UDim2.new(0, 10, 0, 2)
Line1.Position = UDim2.new(0, 3, 0, 12)
Line1.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Line1.Rotation = 45
Line1.Parent = ResizeFrame

local Line2 = Instance.new("Frame")
Line2.Size = UDim2.new(0, 10, 0, 2)
Line2.Position = UDim2.new(0, 7, 0, 8)
Line2.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Line2.Rotation = 45
Line2.Parent = ResizeFrame

-- Рамка для перемещения
local DragFrame = Instance.new("Frame")
DragFrame.Size = UDim2.new(1, 0, 0, 40)
DragFrame.BackgroundTransparency = 1
DragFrame.Parent = MainFrame

-- Перетаскивание
local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

DragFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

DragFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Изменение размера (только когда не свернуто)
local resizing = false
local resizeInput
local startSize
local startMousePos

local function updateResize(input)
    if windowMinimized then return end -- Нельзя изменять размер когда свернуто
    
    local delta = input.Position - startMousePos
    local newWidth = math.max(300, startSize.X.Offset + delta.X)
    local newHeight = math.max(500, startSize.Y.Offset + delta.Y)
    
    MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    windowFullSize = MainFrame.Size -- Сохраняем новый размер
end

ResizeFrame.InputBegan:Connect(function(input)
    if windowMinimized then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        startSize = MainFrame.Size
        startMousePos = input.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end
end)

ResizeFrame.InputChanged:Connect(function(input)
    if windowMinimized then return end
    
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        resizeInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == resizeInput and resizing then
        updateResize(input)
    end
end)

-- Контейнер для элементов
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 5
Container.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Container

-- Индикатор состояния окна
local function updateWindowStateIndicator()
    if windowMinimized then
        Title.Text = "ESP + Speed + Aim [Свернуто] (RSHIFT)"
    else
        Title.Text = "ESP + Speed + Silent Aim (RSHIFT)"
    end
end

-- Подписываемся на изменение состояния
windowMinimizedChanged = windowMinimized -- Для отслеживания
spawn(function()
    while true do
        if windowMinimizedChanged ~= windowMinimized then
            windowMinimizedChanged = windowMinimized
            updateWindowStateIndicator()
        end
        wait(0.1)
    end
end)

-- Функция создания чекбокса (остается без изменений)
local function createCheckbox(name, default, callback, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BackgroundTransparency = 0.3
    frame.LayoutOrder = order or 0
    frame.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 25, 0, 25)
    button.Position = UDim2.new(1, -35, 0.5, -12.5)
    button.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    button.Text = ""
    button.Parent = frame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    local enabled = default
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(enabled)
    end)
    
    return frame
end

-- Функция создания слайдера
local function createSlider(name, min, max, default, callback, order, format, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BackgroundTransparency = 0.3
    frame.LayoutOrder = order or 0
    frame.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. (format and string.format(format, default) or math.floor(default)) .. (suffix or "")
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 5)
    slider.Position = UDim2.new(0, 10, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 15, 0, 15)
    handle.Position = UDim2.new((default - min) / (max - min), -7.5, 0.5, -7.5)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Text = ""
    handle.Parent = slider
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    local dragging = false
    
    handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition
            local sliderSize = slider.AbsoluteSize.X
            
            local pos = math.clamp((mousePos.X - sliderPos.X) / sliderSize, 0, 1)
            local value = min + (max - min) * pos
            
            fill.Size = UDim2.new(pos, 0, 1, 0)
            handle.Position = UDim2.new(pos, -7.5, 0.5, -7.5)
            label.Text = name .. ": " .. (format and string.format(format, value) or math.floor(value)) .. (suffix or "")
            callback(value)
        end
    end)
    
    return frame
end

-- Функция создания сепаратора
local function createSeparator(text, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order or 0
    frame.Parent = Container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 18
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    line.Parent = frame
    
    return frame
end

-- Система Speed
local function updateSpeed()
    if not speedEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = getWalkSpeed()
    end
end

local function resetSpeed()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = baseWalkSpeed
    end
end

-- Функция для получения ближайшей цели для Silent Aim
local function getClosestTarget()
    local closestTarget = nil
    local closestDistance = aimFOV
    local mousePos = UserInputService:GetMouseLocation()
    local mouseRay = camera:ScreenPointToRay(mousePos.X, mousePos.Y)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                -- Проверка видимости
                if aimVisibleCheck then
                    local ray = Ray.new(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 1000)
                    local hit, position = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                    if hit and hit:IsDescendantOf(player.Character) == false then
                        continue
                    end
                end
                
                -- Конвертация 3D позиции в 2D экрана
                local screenPoint, onScreen = camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = head
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Система Silent Aim
local function handleSilentAim()
    if not silentAimEnabled then return end
    
    local target = getClosestTarget()
    if target then
        silentAimTarget = target
        
        -- Создаем или обновляем индикатор цели
        if not _G.targetIndicator then
            _G.targetIndicator = Instance.new("BillboardGui")
            _G.targetIndicator.Name = "TargetIndicator"
            _G.targetIndicator.Size = UDim2.new(0, 50, 0, 50)
            _G.targetIndicator.AlwaysOnTop = true
            _G.targetIndicator.Parent = CoreGui
            
            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(1, 0, 1, 0)
            circle.BackgroundTransparency = 1
            circle.BorderSizePixel = 0
            circle.Parent = _G.targetIndicator
            
            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(1, 0)
            uiCorner.Parent = circle
            
            local image = Instance.new("ImageLabel")
            image.Size = UDim2.new(1, 0, 1, 0)
            image.BackgroundTransparency = 1
            image.Image = "rbxasset://textures/ui/WhiteCircle.png"
            image.ImageColor3 = Color3.fromRGB(255, 0, 0)
            image.ImageTransparency = 0.5
            image.Parent = circle
        end
        
        _G.targetIndicator.Adornee = target
        _G.targetIndicator.Enabled = true
    else
        silentAimTarget = nil
        if _G.targetIndicator then
            _G.targetIndicator.Enabled = false
        end
    end
end

-- Перехват мыши для Silent Aim
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" then
        if silentAimEnabled and silentAimTarget then
            local args = {...}
            if silentAimTarget and silentAimTarget.Parent then
                return silentAimTarget.CFrame.Position, silentAimTarget.Material
            end
        end
    elseif method == "GetMouseLocation" and silentAimEnabled and silentAimTarget then
        -- Корректировка позиции мыши для плавности
        local mousePos = UserInputService:GetMouseLocation()
        local targetPos, onScreen = camera:WorldToScreenPoint(silentAimTarget.Position)
        if onScreen then
            local smoothPos = Vector2.new(
                mousePos.X + (targetPos.X - mousePos.X) * aimSmoothness,
                mousePos.Y + (targetPos.Y - mousePos.Y) * aimSmoothness
            )
            return smoothPos
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Система ESP
local espEnabled = false
local boxEnabled = false
local nameEnabled = false
local distanceEnabled = false
local maxDistance = 3000
local espColor = Color3.fromRGB(255, 0, 0)

-- Создание элементов управления
createSeparator("⚡ SPEED ⚡", 1)

createCheckbox("Enable Speed", false, function(state)
    speedEnabled = state
    if not state then
        resetSpeed()
    else
        updateSpeed()
    end
end, 2)

createSlider("Speed Multiplier", 1.0, 4.0, 1.0, function(value)
    speedMultiplier = value
    if speedEnabled then
        updateSpeed()
    end
end, 3, "%.1f", "x (" .. math.floor(baseWalkSpeed * 1.0) .. "-" .. math.floor(baseWalkSpeed * 4.0) .. ")")

-- Информация о скорости
local speedInfo = Instance.new("Frame")
speedInfo.Size = UDim2.new(1, -10, 0, 25)
speedInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedInfo.BackgroundTransparency = 0.3
speedInfo.LayoutOrder = 4
speedInfo.Parent = Container

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 5)
infoCorner.Parent = speedInfo

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 1, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Current Speed: 16 (1.0x)"
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
infoLabel.TextSize = 14
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = speedInfo

-- Обновление информации о скорости
RunService.RenderStepped:Connect(function()
    if speedEnabled then
        local currentSpeed = getWalkSpeed()
        infoLabel.Text = string.format("Current Speed: %d (%.1fx)", currentSpeed, speedMultiplier)
    else
        infoLabel.Text = "Current Speed: 16 (1.0x)"
    end
end)

createSeparator("🎯 SILENT AIM 🎯", 5)

createCheckbox("Enable Silent Aim", false, function(state)
    silentAimEnabled = state
    if not state and _G.targetIndicator then
        _G.targetIndicator.Enabled = false
    end
end, 6)

createCheckbox("Visible Check", true, function(state)
    aimVisibleCheck = state
end, 7)

createSlider("Aim FOV", 30, 360, 90, function(value)
    aimFOV = value
end, 8, "%.0f", "°")

createSlider("Smoothness", 0.1, 1.0, 0.5, function(value)
    aimSmoothness = value
end, 9, "%.1f")

-- Информация о цели
local targetInfo = Instance.new("Frame")
targetInfo.Size = UDim2.new(1, -10, 0, 25)
targetInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
targetInfo.BackgroundTransparency = 0.3
targetInfo.LayoutOrder = 10
targetInfo.Parent = Container

local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(0, 5)
targetCorner.Parent = targetInfo

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 1, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Target: None"
targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetLabel.TextSize = 14
targetLabel.Font = Enum.Font.Gotham
targetLabel.Parent = targetInfo

createSeparator("🎯 ESP SETTINGS 🎯", 11)

createCheckbox("Enable ESP", false, function(state)
    espEnabled = state
end, 12)

createCheckbox("Show Boxes", false, function(state)
    boxEnabled = state
end, 13)

createCheckbox("Show Names", false, function(state)
    nameEnabled = state
end, 14)

createCheckbox("Show Distance", false, function(state)
    distanceEnabled = state
end, 15)

createSeparator("📏 DISTANCE", 16)

createSlider("Max Distance", 100, 3000, 3000, function(value)
    maxDistance = value
end, 17)

createSeparator("🎨 COLOR", 18)

-- Кнопки выбора цвета
local colorFrame = Instance.new("Frame")
colorFrame.Size = UDim2.new(1, -10, 0, 45)
colorFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
colorFrame.BackgroundTransparency = 0.3
colorFrame.LayoutOrder = 19
colorFrame.Parent = Container

local colorCorner = Instance.new("UICorner")
colorCorner.CornerRadius = UDim.new(0, 5)
colorCorner.Parent = colorFrame

local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(1, -10, 0, 20)
colorLabel.Position = UDim2.new(0, 5, 0, 2)
colorLabel.BackgroundTransparency = 1
colorLabel.Text = "ESP Color:"
colorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
colorLabel.TextSize = 14
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.Font = Enum.Font.Gotham
colorLabel.Parent = colorFrame

local colorButtonsFrame = Instance.new("Frame")
colorButtonsFrame.Size = UDim2.new(1, -10, 0, 25)
colorButtonsFrame.Position = UDim2.new(0, 5, 0, 22)
colorButtonsFrame.BackgroundTransparency = 1
colorButtonsFrame.Parent = colorFrame

local colors = {
    {Color = Color3.fromRGB(255, 0, 0), Name = "Red"},
    {Color = Color3.fromRGB(0, 255, 0), Name = "Green"},
    {Color = Color3.fromRGB(0, 0, 255), Name = "Blue"},
    {Color = Color3.fromRGB(255, 255, 0), Name = "Yellow"},
    {Color = Color3.fromRGB(255, 0, 255), Name = "Purple"},
    {Color = Color3.fromRGB(0, 255, 255), Name = "Cyan"}
}

local buttonWidth = 30
local spacing = 5

for i, colorData in ipairs(colors) do
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, buttonWidth, 0, buttonWidth)
    colorBtn.Position = UDim2.new(0, (i-1) * (buttonWidth + spacing), 0, 0)
    colorBtn.BackgroundColor3 = colorData.Color
    colorBtn.Text = ""
    colorBtn.Parent = colorButtonsFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = colorBtn
    
    colorBtn.MouseButton1Click:Connect(function()
        espColor = colorData.Color
        for _, objects in pairs(espObjects) do
            if objects.box then
                objects.box.Color3 = espColor
            end
            if objects.nameLabel then
                objects.nameLabel.TextColor3 = espColor
            end
        end
    end)
end

-- Хранение ESP объектов
local espObjects = {}

-- Функция создания ESP для игрока
local function createESPForPlayer(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart or humanoid.Health <= 0 then return end
    
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            pcall(function() obj:Destroy() end)
        end
    end
    
    local objects = {}
    
    -- BillboardGui для имени и расстояния
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = CoreGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = espColor
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextSize = 14
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = billboard
    
    objects.billboard = billboard
    objects.nameLabel = nameLabel
    objects.distanceLabel = distanceLabel
    
    -- Box ESP
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "BoxESP_" .. player.Name
    box.Adornee = rootPart
    box.Size = rootPart.Size * 2.5
    box.Transparency = 0.5
    box.Color3 = espColor
    box.ZIndex = 5
    box.AlwaysOnTop = true
    box.Visible = false
    box.Parent = CoreGui
    
    objects.box = box
    
    espObjects[player] = objects
end

-- Обновление ESP
local function updateESP()
    if not espEnabled then
        for _, objects in pairs(espObjects) do
            if objects.billboard then
                objects.billboard.Enabled = false
            end
            if objects.box then
                objects.box.Visible = false
            end
        end
        return
    end
    
    local localPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localPosition then return end
    
    for player, objects in pairs(espObjects) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if character and rootPart then
            local distance = (rootPart.Position - localPosition.Position).Magnitude
            
            if distance <= maxDistance then
                if objects.billboard then
                    objects.billboard.Enabled = nameEnabled or distanceEnabled
                    
                    if nameEnabled then
                        objects.nameLabel.Visible = true
                        objects.nameLabel.Text = player.Name
                    else
                        objects.nameLabel.Visible = false
                    end
                    
                    if distanceEnabled then
                        objects.distanceLabel.Visible = true
                        objects.distanceLabel.Text = math.floor(distance) .. " studs"
                    else
                        objects.distanceLabel.Visible = false
                    end
                end
                
                if objects.box and boxEnabled then
                    objects.box.Visible = true
                    objects.box.Size = rootPart.Size * 2.5
                elseif objects.box then