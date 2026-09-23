-- MM2 COIN FARMER
-- simple menu, auto farm, coin counter

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

local CONFIG = {
    farmEnabled = false,
    coinCount = 0,
    farmRange = 50,
    teleportDelay = 0.15,
    accent = Color3.fromRGB(120, 200, 255),
    bg = Color3.fromRGB(15, 15, 20),
    panel = Color3.fromRGB(22, 22, 30),
    element = Color3.fromRGB(35, 35, 48),
    text = Color3.fromRGB(240, 240, 250),
    textDim = Color3.fromRGB(140, 140, 160),
    outline = Color3.fromRGB(50, 50, 70),
}

local function new(cls, props)
    local inst = Instance.new(cls)
    for k, v in pairs(props or {}) do inst[k] = v end
    return inst
end

local function corner(inst, r)
    return new("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = inst})
end

local function stroke(inst, color, thickness, trans)
    return new("UIStroke", {
        Color = color or CONFIG.outline,
        Thickness = thickness or 1,
        Transparency = trans or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = inst,
    })
end

local function tween(inst, time, props)
    local t = TweenService:Create(inst, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local gui = new("ScreenGui", {
    Name = "CoinFarmer",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

local window = new("Frame", {
    Name = "Window",
    Size = UDim2.new(0, 320, 0, 200),
    Position = UDim2.new(0.5, -160, 0.5, -100),
    BackgroundColor3 = CONFIG.bg,
    BorderSizePixel = 0,
    Visible = false,
    Parent = gui,
})
corner(window, 14)
stroke(window, CONFIG.outline, 1, 0.3)

new("ImageLabel", {
    BackgroundTransparency = 1,
    Image = "rbxassetid://5028857084",
    ImageColor3 = Color3.new(0, 0, 0),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(24, 24, 276, 276),
    Size = UDim2.new(1, 30, 1, 30),
    Position = UDim2.new(0, -15, 0, -15),
    ZIndex = -1,
    Parent = window,
})

local accentBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 3),
    BackgroundColor3 = CONFIG.accent,
    BorderSizePixel = 0,
    Parent = window,
})
corner(accentBar, 3)
new("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, CONFIG.accent),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 120, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 200)),
    },
    Parent = accentBar,
})

new("TextLabel", {
    Size = UDim2.new(1, -40, 0, 30),
    Position = UDim2.new(0, 16, 0, 8),
    BackgroundTransparency = 1,
    Text = "💰 COIN FARMER",
    TextColor3 = CONFIG.text,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = window,
})

local closeBtn = new("TextButton", {
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -34, 0, 8),
    BackgroundColor3 = CONFIG.element,
    Text = "X",
    TextColor3 = CONFIG.text,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Parent = window,
})
corner(closeBtn, 6)
closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 80, 80), TextColor3 = Color3.new(1,1,1)})
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = CONFIG.element, TextColor3 = CONFIG.text})
end)
closeBtn.MouseButton1Click:Connect(function()
    tween(window, 0.2, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
    task.wait(0.21)
    window.Visible = false
end)

local counterBox = new("Frame", {
    Size = UDim2.new(1, -32, 0, 60),
    Position = UDim2.new(0, 16, 0, 48),
    BackgroundColor3 = CONFIG.panel,
    BorderSizePixel = 0,
    Parent = window,
})
corner(counterBox, 10)
stroke(counterBox, CONFIG.outline, 1, 0.5)

new("TextLabel", {
    Size = UDim2.new(1, -20, 0, 16),
    Position = UDim2.new(0, 12, 0, 8),
    BackgroundTransparency = 1,
    Text = "COINS COLLECTED",
    TextColor3 = CONFIG.textDim,
    Font = Enum.Font.GothamMedium,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = counterBox,
})

local coinLabel = new("TextLabel", {
    Size = UDim2.new(1, -20, 0, 32),
    Position = UDim2.new(0, 12, 0, 24),
    BackgroundTransparency = 1,
    Text = "0",
    TextColor3 = CONFIG.accent,
    Font = Enum.Font.GothamBold,
    TextSize = 28,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = counterBox,
})

local farmBtn = new("TextButton", {
    Size = UDim2.new(1, -32, 0, 44),
    Position = UDim2.new(0, 16, 0, 120),
    BackgroundColor3 = CONFIG.element,
    Text = "",
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Parent = window,
})
corner(farmBtn, 10)
local farmStroke = stroke(farmBtn, CONFIG.outline, 1, 0.3)

local farmLabel = new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "▶  START FARMING",
    TextColor3 = CONFIG.text,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    Parent = farmBtn,
})

local function updateFarmBtn()
    if CONFIG.farmEnabled then
        farmLabel.Text = "■  STOP FARMING"
        farmLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        tween(farmBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(50, 25, 30)})
        tween(farmStroke, 0.2, {Color = Color3.fromRGB(255, 80, 80), Transparency = 0})
    else
        farmLabel.Text = "▶  START FARMING"
        farmLabel.TextColor3 = CONFIG.text
        tween(farmBtn, 0.2, {BackgroundColor3 = CONFIG.element})
        tween(farmStroke, 0.2, {Color = CONFIG.outline, Transparency = 0.3})
    end
end

farmBtn.MouseEnter:Connect(function()
    if not CONFIG.farmEnabled then
        tween(farmBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)})
    end
end)
farmBtn.MouseLeave:Connect(function()
    if not CONFIG.farmEnabled then
        tween(farmBtn, 0.15, {BackgroundColor3 = CONFIG.element})
    end
end)
farmBtn.MouseButton1Click:Connect(function()
    CONFIG.farmEnabled = not CONFIG.farmEnabled
    updateFarmBtn()
end)

local dragging, dragStart, startPos
local dragBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = window,
})
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local toggleBtn = new("TextButton", {
    Size = UDim2.fromOffset(52, 52),
    Position = UDim2.new(0, 20, 0.5, -26),
    BackgroundColor3 = CONFIG.panel,
    Text = "💰",
    TextColor3 = CONFIG.text,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Parent = gui,
})
corner(toggleBtn, 26)
local toggleStroke = stroke(toggleBtn, CONFIG.accent, 2, 0)
new("ImageLabel", {
    BackgroundTransparency = 1,
    Image = "rbxassetid://5028857084",
    ImageColor3 = Color3.new(0, 0, 0),
    ImageTransparency = 0.6,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(24, 24, 276, 276),
    Size = UDim2.new(1, 20, 1, 20),
    Position = UDim2.new(0, -10, 0, -10),
    ZIndex = -1,
    Parent = toggleBtn,
})

local glow = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = CONFIG.accent,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = -2,
    Parent = toggleBtn,
})
corner(glow, 26)

task.spawn(function()
    while gui.Parent do
        if CONFIG.farmEnabled then
            tween(glow, 0.8, {BackgroundTransparency = 0.6, Size = UDim2.new(1, 20, 1, 20), Position = UDim2.new(0, -10, 0, -10)})
            task.wait(0.85)
            tween(glow, 0.8, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)})
            task.wait(0.85)
        else
            glow.BackgroundTransparency = 1
            glow.Size = UDim2.new(1, 0, 1, 0)
            glow.Position = UDim2.new(0, 0, 0, 0)
            task.wait(0.2)
        end
    end
end)

toggleBtn.MouseEnter:Connect(function()
    tween(toggleBtn, 0.15, {Size = UDim2.fromOffset(58, 58), Position = UDim2.new(0, 17, 0.5, -29)})
end)
toggleBtn.MouseLeave:Connect(function()
    tween(toggleBtn, 0.15, {Size = UDim2.fromOffset(52, 52), Position = UDim2.new(0, 20, 0.5, -26)})
end)

local windowOpen = false

local function openWindow()
    windowOpen = true
    window.Visible = true
    window.Size = UDim2.new(0, 0, 0, 0)
    window.Position = UDim2.new(0.5, 0, 0.5, 0)
    tween(window, 0.28, {
        Size = UDim2.new(0, 320, 0, 200),
        Position = UDim2.new(0.5, -160, 0.5, -100),
    })
end

local function closeWindow()
    windowOpen = false
    tween(window, 0.2, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    })
    task.wait(0.21)
    window.Visible = false
end

local function toggleWindow()
    if windowOpen then
        closeWindow()
    else
        openWindow()
    end
end

toggleBtn.MouseButton1Click:Connect(toggleWindow)

local tDrag, tStart, tPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tDrag = true
        tStart = input.Position
        tPos = toggleBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if tDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - tStart
        toggleBtn.Position = UDim2.new(tPos.X.Scale, tPos.X.Offset + d.X, tPos.Y.Scale, tPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tDrag = false
    end
end)

local function teleportTo(obj)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if obj:IsA("BasePart") then
        hrp.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
    elseif obj:IsA("Model") and obj.PrimaryPart then
        hrp.CFrame = obj.PrimaryPart.CFrame + Vector3.new(0, 2, 0)
    end
end

local function findCoins()
    local coins = {}
    local char = LP.Character
    if not char then return coins end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return coins end

    for _, obj in ipairs(workspace:GetChildren()) do
        local name = string.lower(obj.Name)
        if name == "coin" or name == "coinbag" or name == "coindrop" or name:find("coin") then
            local pos
            if obj:IsA("BasePart") then
                pos = obj.Position
            elseif obj:IsA("Model") and obj.PrimaryPart then
                pos = obj.PrimaryPart.Position
            end
            if pos then
                local dist = (pos - hrp.Position).Magnitude
                if dist <= CONFIG.farmRange then
                    table.insert(coins, {obj = obj, dist = dist})
                end
            end
        end
    end

    table.sort(coins, function(a, b) return a.dist < b.dist end)
    return coins
end

local lastCoinCount = 0

task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        pcall(function()
            local coins = 0
            local char = LP.Character
            if char then
                for _, d in ipairs(char:GetDescendants()) do
                    local n = string.lower(d.Name)
                    if n:find("coin") and d:IsA("BasePart") then
                        coins = coins + 1
                    end
                end
            end
            local bp = LP:FindFirstChild("Backpack")
            if bp then
                for _, d in ipairs(bp:GetDescendants()) do
                    local n = string.lower(d.Name)
                    if n:find("coin") and d:IsA("BasePart") then
                        coins = coins + 1
                    end
                end
            end
            if coins > lastCoinCount then
                CONFIG.coinCount = CONFIG.coinCount + (coins - lastCoinCount)
                lastCoinCount = coins
                coinLabel.Text = tostring(CONFIG.coinCount)
                tween(coinLabel, 0.15, {TextColor3 = Color3.fromRGB(255, 220, 100)})
                task.wait(0.15)
                tween(coinLabel, 0.15, {TextColor3 = CONFIG.accent})
            end
        end)
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(CONFIG.teleportDelay)
        if CONFIG.farmEnabled then
            pcall(function()
                local coins = findCoins()
                for _, entry in ipairs(coins) do
                    if not CONFIG.farmEnabled then break end
                    teleportTo(entry.obj)
                    task.wait(0.05)
                end
            end)
        end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        toggleWindow()
    end
end)

print("[Coin Farmer] loaded - K to toggle")
