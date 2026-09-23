local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local cam = workspace.CurrentCamera

local CFG = {
    FlySpeed = 120, FlySmooth = 0.15, WalkSpeed = 40, JumpPower = 120, FOV = 90,
    AuraRange = 22, AutoShoot = true, AutoDodge = true, AutoGun = true, KillAura = true,
    ESP = true, ESPBox = true, ESPName = true, ESPRole = true,
    GunESP = true, CoinESP = true,
    Fullbright = true, Noclip = false, Ghost = false, WaterProt = true, AntiFling = true,
    Theme = "dark",
    Accent = Color3.fromRGB(150, 80, 255),
    AnimSpeed = 0.25,
}

local Theme = {
    dark = {
        bg = Color3.fromRGB(15, 14, 22),
        panel = Color3.fromRGB(22, 20, 32),
        section = Color3.fromRGB(28, 25, 40),
        element = Color3.fromRGB(38, 34, 52),
        text = Color3.fromRGB(240, 240, 250),
        textDim = Color3.fromRGB(140, 135, 165),
        outline = Color3.fromRGB(50, 45, 70),
        danger = Color3.fromRGB(255, 80, 80),
        success = Color3.fromRGB(80, 255, 160),
    },
    light = {
        bg = Color3.fromRGB(245, 243, 250),
        panel = Color3.fromRGB(255, 255, 255),
        section = Color3.fromRGB(240, 238, 250),
        element = Color3.fromRGB(228, 225, 240),
        text = Color3.fromRGB(30, 28, 45),
        textDim = Color3.fromRGB(120, 115, 145),
        outline = Color3.fromRGB(210, 205, 225),
        danger = Color3.fromRGB(220, 60, 60),
        success = Color3.fromRGB(60, 190, 120),
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

local function corner(inst, radius)
    return new("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = inst })
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

local function tween(inst, time, props, style, dir)
    local ti = TweenInfo.new(time or CFG.AnimSpeed, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, ti, props)
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

local Window = {}
Window.__index = Window

local function createWindow(title, subtitle)
    local self = setmetatable({}, Window)
    self.tabs = {}
    self.activeTab = nil
    self.visible = true

    self.frame = new("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 620, 0, 420),
        Position = UDim2.new(0.5, -310, 0.5, -210),
        BackgroundColor3 = C("panel"),
        BorderSizePixel = 0,
        Parent = gui,
    })
    corner(self.frame, 14)
    self.stroke = stroke(self.frame, C("outline"), 1, 0.3)

    new("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        ZIndex = -1,
        Parent = self.frame,
    })

    local titleBar = new("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = C("section"),
        BorderSizePixel = 0,
        Parent = self.frame,
    })
    corner(titleBar, 14)
    new("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = C("section"),
        BorderSizePixel = 0,
        Parent = titleBar,
    })

    local grad = new("Frame", {
        Name = "AccentLine",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = CFG.Accent,
        BorderSizePixel = 0,
        Parent = self.frame,
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

    local iconHolder = new("Frame", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 14, 0.5, -16),
        BackgroundColor3 = CFG.Accent,
        BorderSizePixel = 0,
        Parent = titleBar,
    })
    corner(iconHolder, 8)
    new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "D",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        Parent = iconHolder,
    })

    self.titleLabel = new("TextLabel", {
        Size = UDim2.new(1, -180, 0, 20),
        Position = UDim2.new(0, 56, 0, 8),
        BackgroundTransparency = 1,
        Text = title or "MM2 DOMINATOR",
        TextColor3 = C("text"),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
    })
    self.subtitleLabel = new("TextLabel", {
        Size = UDim2.new(1, -180, 0, 14),
        Position = UDim2.new(0, 56, 0, 28),
        BackgroundTransparency = 1,
        Text = subtitle or "v4 by rodnoy",
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
    minBtn.MouseEnter:Connect(function() tween(minBtn, 0.15, { BackgroundColor3 = C("outline") }) end)
    minBtn.MouseLeave:Connect(function() tween(minBtn, 0.15, { BackgroundColor3 = C("element") }) end)
    minBtn.MouseButton1Click:Connect(function()
        self.visible = not self.visible
        local targetPos = self.visible and UDim2.new(0.5, -310, 0.5, -210) or UDim2.new(0.5, -310, 1.5, 0)
        tween(self.frame, 0.3, { Position = targetPos })
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
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, 0.15, { BackgroundColor3 = C("danger"), TextColor3 = Color3.new(1, 1, 1) })
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, 0.15, { BackgroundColor3 = C("element"), TextColor3 = C("text") })
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(self.frame, 0.25, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) })
        task.wait(0.26)
        gui.Enabled = false
    end)

    self.tabBar = new("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, 140, 1, -68),
        Position = UDim2.new(0, 12, 0, 60),
        BackgroundTransparency = 1,
        Parent = self.frame,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.tabBar,
    })

    self.content = new("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -168, 1, -68),
        Position = UDim2.new(0, 156, 0, 60),
        BackgroundTransparency = 1,
        Parent = self.frame,
    })

    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    return self
end

function Window:Tab(name)
    if self.tabs[name] then return self.tabs[name] end

    local isFirst = #self.tabBar:GetChildren() == 1
    local btn = new("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = C("element"),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = self.tabBar,
    })
    corner(btn, 8)

    local indicator = new("Frame", {
        Size = UDim2.new(0, 3, 0.5, 0),
        Position = UDim2.new(0, -6, 0.5, 0),
        BackgroundColor3 = CFG.Accent,
        BorderSizePixel = 0,
        Parent = btn,
    })
    corner(indicator, 2)
    indicator.Visible = false

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

    local contentHolder = new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CFG.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = self.content,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = contentHolder,
    })
    new("UIPadding", {
        PaddingRight = UDim.new(0, 6),
        Parent = contentHolder,
    })

    local tab = {
        name = name,
        button = btn,
        label = label,
        indicator = indicator,
        content = contentHolder,
    }

    btn.MouseEnter:Connect(function()
        if self.activeTab ~= tab then tween(btn, 0.15, { BackgroundTransparency = 0.5 }) end
    end)
    btn.MouseLeave:Connect(function()
        if self.activeTab ~= tab then tween(btn, 0.15, { BackgroundTransparency = 1 }) end
    end)
    btn.MouseButton1Click:Connect(function() self:Select(tab) end)

    self.tabs[name] = tab
    if isFirst then
        task.defer(function() self:Select(tab) end)
    end

    return tab
end

function Window:Select(tab)
    if self.activeTab == tab then return end
    if self.activeTab then
        tween(self.activeTab.button, 0.15, { BackgroundTransparency = 1 })
        tween(self.activeTab.label, 0.15, { TextColor3 = C("textDim") })
        self.activeTab.indicator.Visible = false
        self.activeTab.content.Visible = false
    end
    self.activeTab = tab
    tween(tab.button, 0.15, { BackgroundTransparency = 0, BackgroundColor3 = C("element") })
    tween(tab.label, 0.15, { TextColor3 = C("text") })
    tab.indicator.Visible = true
    tab.content.Visible = true
end

local function Section(tab, title)
    local section = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C("section"),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = tab.content,
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
        Name = "Holder",
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

local function Toggle(parent, opts)
    opts = opts or {}
    local value = opts.Default or false
    local row = new("Frame", {
        Name = "Toggle",
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
    local boxStroke = stroke(box, C("outline"), 1, 0.3)
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
    btn.MouseEnter:Connect(function() tween(label, 0.15, { TextColor3 = CFG.Accent }) end)
    btn.MouseLeave:Connect(function() tween(label, 0.15, { TextColor3 = C("text") }) end)

    render()
    return {
        Set = function(v) value = v; render(); if opts.Callback then opts.Callback(v) end end,
        Get = function() return value end,
    }
end

local function Slider(parent, opts)
    opts = opts or {}
    local value = opts.Default or 0
    local min = opts.Min or 0
    local max = opts.Max or 100
    local suffix = opts.Suffix or ""

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
        Text = tostring(value) .. suffix,
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
    new("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, CFG.Accent),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 200)),
        },
        Parent = fill,
    })
    local knob = new("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, -7, 0.5, -7),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = bar,
    })
    corner(knob, 7)
    stroke(knob, CFG.Accent, 2, 0)

    local function update(v)
        value = math.clamp(v, min, max)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        valLabel.Text = tostring(math.floor(value * 100 + 0.5) / 100) .. suffix
        if opts.Callback then task.spawn(opts.Callback, value) end
    end

    local dragging = false
    local function inputFromX(mouseX)
        local rel = (mouseX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
        return min + (max - min) * math.clamp(rel, 0, 1)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(inputFromX(input.Position.X))
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(inputFromX(input.Position.X))
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

local function Button(parent, opts)
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
    local s = stroke(row, C("outline"), 1, 0.5)
    new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = opts.Text or "Button",
        TextColor3 = C("text"),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        Parent = row,
    })
    row.MouseEnter:Connect(function()
        tween(row, 0.15, { BackgroundColor3 = CFG.Accent })
        tween(s, 0.15, { Color = CFG.Accent, Transparency = 0 })
    end)
    row.MouseLeave:Connect(function()
        tween(row, 0.15, { BackgroundColor3 = C("element") })
        tween(s, 0.15, { Color = C("outline"), Transparency = 0.5 })
    end)
    row.MouseButton1Click:Connect(function()
        if opts.Callback then task.spawn(opts.Callback) end
    end)
    return row
end

local function Input(parent, opts)
    opts = opts or {}
    local value = opts.Default or ""
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Text = opts.Text or "Input",
        TextColor3 = C("text"),
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local box = new("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0, 16),
        BackgroundColor3 = C("element"),
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(box, 6)
    local s = stroke(box, C("outline"), 1, 0.5)
    local tb = new("TextBox", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = value,
        PlaceholderText = opts.Placeholder or "...",
        PlaceholderColor3 = C("textDim"),
        TextColor3 = C("text"),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = box,
    })
    tb.Focused:Connect(function() tween(s, 0.15, { Color = CFG.Accent, Transparency = 0 }) end)
    tb.FocusLost:Connect(function()
        tween(s, 0.15, { Color = C("outline"), Transparency = 0.5 })
        value = tb.Text
        if opts.Callback then task.spawn(opts.Callback, value) end
    end)
    return tb
end

local function Dropdown(parent, opts)
    opts = opts or {}
    local values = opts.Values or {}
    local selected = opts.Default or values[1] or "..."
    local open = false

    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Text = opts.Text or "Dropdown",
        TextColor3 = C("text"),
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local box = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0, 16),
        BackgroundColor3 = C("element"),
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(box, 6)
    local s = stroke(box, C("outline"), 1, 0.5)
    local valLabel = new("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = selected,
        TextColor3 = C("text"),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = box,
    })
    local arrow = new("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -22, 0, 0),
        BackgroundTransparency = 1,
        Text = "v",
        TextColor3 = C("textDim"),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = box,
    })

    local list = new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = C("panel"),
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = CFG.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 10,
        Parent = row,
    })
    corner(list, 6)
    stroke(list, C("outline"), 1, 0.3)
    local layout = new("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = list,
    })
    new("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        Parent = list,
    })

    local function refresh()
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for i, v in ipairs(values) do
            local item = new("TextButton", {
                Size = UDim2.new(1, -8, 0, 22),
                BackgroundColor3 = (v == selected) and CFG.Accent or C("element"),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                LayoutOrder = i,
                Parent = list,
            })
            corner(item, 4)
            new("TextLabel", {
                Size = UDim2.new(1, -8, 1, 0),
                Position = UDim2.new(0, 6, 0, 0),
                BackgroundTransparency = 1,
                Text = v,
                TextColor3 = (v == selected) and Color3.new(1, 1, 1) or C("text"),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = item,
            })
            item.MouseButton1Click:Connect(function()
                selected = v
                valLabel.Text = v
                open = false
                tween(list, 0.2, { Size = UDim2.new(1, 0, 0, 0), Visible = false })
                arrow.Text = "v"
                refresh()
                if opts.Callback then task.spawn(opts.Callback, selected) end
            end)
        end
        list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end

    box.MouseButton1Click:Connect(function()
        open = not open
        if open then
            list.Visible = true
            tween(list, 0.2, { Size = UDim2.new(1, 0, 0, math.min(#values * 24 + 8, 140)) })
            arrow.Text = "^"
        else
            tween(list, 0.2, { Size = UDim2.new(1, 0, 0, 0) })
            task.delay(0.2, function() list.Visible = false end)
            arrow.Text = "v"
        end
    end)

    refresh()
    return {
        Get = function() return selected end,
        Set = function(v)
            selected = v
            valLabel.Text = v
            refresh()
            if opts.Callback then opts.Callback(v) end
        end,
    }
end

local function Keybind(parent, opts)
    opts = opts or {}
    local value = opts.Default or "None"
    local listening = false

    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(1, -110, 1, 0),
        BackgroundTransparency = 1,
        Text =
