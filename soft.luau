local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

local CFG = {
    Theme = "dark",
    Accent = Color3.fromRGB(150, 80, 255),
    AnimSpeed = 0.2,
}

local Theme = {
    dark = {
        panel = Color3.fromRGB(22, 20, 32),
        section = Color3.fromRGB(28, 25, 40),
        element = Color3.fromRGB(38, 34, 52),
        text = Color3.fromRGB(240, 240, 250),
        textDim = Color3.fromRGB(140, 135, 165),
        outline = Color3.fromRGB(50, 45, 70),
        danger = Color3.fromRGB(255, 80, 80),
    },
    light = {
        panel = Color3.fromRGB(255, 255, 255),
        section = Color3.fromRGB(240, 238, 250),
        element = Color3.fromRGB(228, 225, 240),
        text = Color3.fromRGB(30, 28, 45),
        textDim = Color3.fromRGB(120, 115, 145),
        outline = Color3.fromRGB(210, 205, 225),
        danger = Color3.fromRGB(220, 60, 60),
    },
}

local function C(key)
    return Theme[CFG.Theme][key] or Color3.new(1, 1, 1)
end

local function new(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    return inst
end

local function corner(inst, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = inst })
end

local function stroke(inst, color, thickness, transparency)
    return new("UIStroke", {
        Color = color or C("outline"),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = inst,
    })
end

local function tween(inst, time, props)
    local t = TweenService:Create(inst, TweenInfo.new(time or CFG.AnimSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local gui = new("ScreenGui", {
    Name = "MM2Dominator",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

local main = new("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 620, 0, 420),
    Position = UDim2.new(0.5, -310, 0.5, -210),
    BackgroundColor3 = C("panel"),
    BorderSizePixel = 0,
    Parent = gui,
})
corner(main, 14)
stroke(main, C("outline"), 1, 0.3)

local grad = new("Frame", {
    Size = UDim2.new(1, 0, 0, 3),
    BackgroundColor3 = CFG.Accent,
    BorderSizePixel = 0,
    Parent = main,
})
corner(grad, 3)
new("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, CFG.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 255)),
    },
    Parent = grad,
})

local titleBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = C("section"),
    BorderSizePixel = 0,
    Parent = main,
})
corner(titleBar, 14)
new("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = C("section"),
    BorderSizePixel = 0,
    Parent = titleBar,
})

local iconBox = new("Frame", {
    Size = UDim2.fromOffset(32, 32),
    Position = UDim2.new(0, 14, 0.5, -16),
    BackgroundColor3 = CFG.Accent,
    BorderSizePixel = 0,
    Parent = titleBar,
})
corner(iconBox, 8)
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "D",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    Parent = iconBox,
})

new("TextLabel", {
    Size = UDim2.new(1, -180, 0, 20),
    Position = UDim2.new(0, 56, 0, 8),
    BackgroundTransparency = 1,
    Text = "MM2 DOMINATOR",
    TextColor3 = C("text"),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = titleBar,
})
new("TextLabel", {
    Size = UDim2.new(1, -180, 0, 14),
    Position = UDim2.new(0, 56, 0, 28),
    BackgroundTransparency = 1,
    Text = "v4 by rodnoy",
    TextColor3 = C("textDim"),
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = titleBar,
})

local minBtn = new("TextButton", {
    Size = UDim2.fromOffset(28, 28),
    Position = UDim2.new(1, -70, 0.5, -14),
    BackgroundColor3 = C("element"),
    Text = "-",
    TextColor3 = C("text"),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Parent = titleBar,
})
corner(minBtn, 6)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tween(main, 0.25, { Position = minimized and UDim2.new(0.5, -310, 1.5, 0) or UDim2.new(0.5, -310, 0.5, -210) })
end)

local closeBtn = new("TextButton", {
    Size = UDim2.fromOffset(28, 28),
    Position = UDim2.new(1, -36, 0.5, -14),
    BackgroundColor3 = C("element"),
    Text = "X",
    TextColor3 = C("text"),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Parent = titleBar,
})
corner(closeBtn, 6)
closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local tabBar = new("Frame", {
    Size = UDim2.new(0, 140, 1, -68),
    Position = UDim2.new(0, 12, 0, 60),
    BackgroundTransparency = 1,
    Parent = main,
})
new("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = tabBar,
})

local content = new("Frame", {
    Size = UDim2.new(1, -168, 1, -68),
    Position = UDim2.new(0, 156, 0, 60),
    BackgroundTransparency = 1,
    Parent = main,
})

local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local tabs = {}
local activeTab = nil

local function selectTab(tab)
    if activeTab == tab then return end
    if activeTab then
        tween(activeTab.btn, 0.15, { BackgroundTransparency = 1 })
        tween(activeTab.label, 0.15, { TextColor3 = C("textDim") })
        activeTab.indicator.Visible = false
        activeTab.scroll.Visible = false
    end
    activeTab = tab
    tween(tab.btn, 0.15, { BackgroundTransparency = 0, BackgroundColor3 = C("element") })
    tween(tab.label, 0.15, { TextColor3 = C("text") })
    tab.indicator.Visible = true
    tab.scroll.Visible = true
end

local function addTab(name)
    if tabs[name] then return tabs[name] end

    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = C("element"),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = tabBar,
    })
    corner(btn, 8)

    local indicator = new("Frame", {
        Size = UDim2.new(0, 3, 0.5, 0),
        Position = UDim2.new(0, -6, 0.5, 0),
        BackgroundColor3 = CFG.Accent,
        BorderSizePixel = 0,
        Visible = false,
        Parent = btn,
    })
    corner(indicator, 2)

    local label = new("TextLabel", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = C("textDim"),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn,
    })

    local scroll = new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CFG.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = content,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scroll,
    })
    new("UIPadding", {
        PaddingRight = UDim.new(0, 6),
        Parent = scroll,
    })

    local tab = { name = name, btn = btn, label = label, indicator = indicator, scroll = scroll }
    tabs[name] = tab

    btn.MouseButton1Click:Connect(function() selectTab(tab) end)

    if not activeTab then
        task.defer(function() selectTab(tab) end)
    end

    return tab
end

local function addSection(tab, title)
    local section = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C("section"),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = tab.scroll,
    })
    corner(section, 10)
    stroke(section, C("outline"), 1, 0.6)

    new("TextLabel", {
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C("text"),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section,
    })

    new("Frame", {
        Size = UDim2.new(1, -16, 0, 1),
        Position = UDim2.new(0, 8, 0, 28),
        BackgroundColor3 = C("outline"),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = section,
    })

    local holder = new("Frame", {
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, 34),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = section,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = holder,
    })
    new("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 6),
        Parent = holder,
    })

    return holder
end

local function addToggle(parent, opts)
    opts = opts or {}
    local value = opts.Default or false
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    local label = new("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = opts.Text or "Toggle",
        TextColor3 = C("text"),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local box = new("Frame", {
        Size = UDim2.fromOffset(40, 20),
        Position = UDim2.new(1, -44, 0.5, -10),
        BackgroundColor3 = C("element"),
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(box, 10)
    stroke(box, C("outline"), 1, 0.3)
    local knob = new("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, 3, 0.5, -7),
        BackgroundColor3 = C("textDim"),
        BorderSizePixel = 0,
        Parent = box,
    })
    corner(knob, 7)

    local function render()
        if value then
            tween(box, 0.15, { BackgroundColor3 = CFG.Accent })
            tween(knob, 0.15, { Position = UDim2.new(1, -17, 0.5, -7), BackgroundColor3 = Color3.new(1, 1, 1) })
        else
            tween(box, 0.15, { BackgroundColor3 = C("element") })
            tween(knob, 0.15, { Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = C("textDim") })
        end
    end

    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = row,
    })
    btn.MouseButton1Click:Connect(function()
        value = not value
        render()
        if opts.Callback then task.spawn(opts.Callback, value) end
    end)

    render()
    return { Set = function(v) value = v; render() end, Get = function() return value end }
end

local function addSlider(parent, opts)
    opts = opts or {}
    local value = opts.Default or 0
    local min, max = opts.Min or 0, opts.Max or 100

    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(1, -70, 0, 16),
        BackgroundTransparency = 1,
        Text = opts.Text or "Slider",
        TextColor3 = C("text"),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local valLabel = new("TextLabel", {
        Size = UDim2.new(0, 60, 0, 16),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = CFG.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row,
    })
    local bar = new("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = C("element"),
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(bar, 3)
    local fill = new("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CFG.Accent,
        BorderSizePixel = 0,
        Parent = bar,
    })
    corner(fill, 3)

    local function update(v)
        value = math.clamp(v, min, max)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        valLabel.Text = tostring(math.floor(value * 100 + 0.5) / 100)
        if opts.Callback then task.spawn(opts.Callback, value) end
    end

    local dragging = false
    local function fromX(x)
        local rel = (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
        return min + (max - min) * math.clamp(rel, 0, 1)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(fromX(input.Position.X))
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(fromX(input.Position.X))
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    update(value)
    return { Set = update, Get = function() return value end }
end

local function addButton(parent, opts)
    opts = opts or {}
    local row = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = C("element"),
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = parent,
    })
    corner(row, 8)
    stroke(row, C("outline"), 1, 0.5)
    new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = opts.Text or "Button",
        TextColor3 = C("text"),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        Parent = row,
    })
    row.MouseEnter:Connect(function() tween(row, 0.15, { BackgroundColor3 = CFG.Accent }) end)
    row.MouseLeave:Connect(function() tween(row, 0.15, { BackgroundColor3 = C("element") }) end)
    row.MouseButton1Click:Connect(function()
        if opts.Callback then task.spawn(opts.Callback) end
    end)
    return row
end

local combatTab = addTab("Combat")
local combatSec = addSection(combatTab, "Kill Aura")
addToggle(combatSec, {
    Text = "Kill Aura",
    Default = true,
    Callback = function(v)
        getgenv().KillAura = v
    end,
})
addSlider(combatSec, {
    Text = "Range",
    Default = 22,
    Min = 5,
    Max = 60,
    Callback = function(v)
        getgenv().AuraRange = v
    end,
})
addToggle(combatSec, {
    Text = "Auto Shoot Murderer",
    Default = true,
    Callback = function(v)
        getgenv().AutoShoot = v
    end,
})
addToggle(combatSec, {
    Text = "Auto Dodge",
    Default = true,
    Callback = function(v)
        getgenv().AutoDodge = v
    end,
})

local movementTab = addTab("Movement")
local moveSec = addSection(movementTab, "Speed")
addSlider(moveSec, {
    Text = "WalkSpeed",
    Default = 40,
    Min = 16,
    Max = 200,
    Callback = function(v)
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end,
})
addSlider(moveSec, {
    Text = "JumpPower",
    Default = 120,
    Min = 50,
    Max = 400,
    Callback = function(v)
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower = true; h.JumpPower = v end
    end,
})
addSlider(moveSec, {
    Text = "FOV",
    Default = 90,
    Min = 70,
    Max = 140,
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
    end,
})

local miscSec = addSection(movementTab, "Other")
addToggle(miscSec, {
    Text = "Fullbright",
    Default = false,
    Callback = function(v)
        if v then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 1e6
        else
            Lighting.Brightness = 1
        end
    end,
})

local espTab = addTab("ESP")
local espSec = addSection(espTab, "Player ESP")
addToggle(espSec, {
    Text = "Enable ESP",
    Default = false,
    Callback = function(v)
        getgenv().ESPEnabled = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local old = p.Character:FindFirstChild("ElisiumESP")
                if old then old:Destroy() end
                if v then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ElisiumESP"
                    hl.FillColor = Color3.fromRGB(255, 50, 50)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.Parent = p.Character
                end
            end
        end
    end,
})
addToggle(espSec, {
    Text = "Gun ESP",
    Default = false,
    Callback = function(v)
        getgenv().GunESP = v
    end,
})

local playersTab = addTab("Players")
local plSec = addSection(playersTab, "Actions")
addButton(plSec, {
    Text = "Teleport to Random Player",
    Callback = function()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(list, p)
            end
        end
        if #list > 0 then
            local target = list[math.random(1, #list)]
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end,
})

local settingsTab = addTab("Settings")
local setSec = addSection(settingsTab, "UI")
addButton(setSec, {
    Text = "Switch Theme",
    Callback = function()
        CFG.Theme = (CFG.Theme == "dark") and "light" or "dark"
    end,
})
addButton(setSec, {
    Text = "Hide Menu (RightShift to open)",
    Callback = function()
        gui.Enabled = false
        UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.RightShift then
                gui.Enabled = true
            end
        end)
    end,
})

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("[MM2 DOMINATOR] loaded")
