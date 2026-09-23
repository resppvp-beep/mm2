--[[
    MM2 DOMINATOR v3
    Самодостаточный скрипт для Murder Mystery 2
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- ============ UI ============
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "MM2 DOMINATOR v3",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by rodnoy",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- ============ STATE ============
local CFG = {
    FlySpeed = 120, WalkSpeed = 40, JumpPower = 120, FOV = 90,
    AuraRange = 22, ESP = true, GunESP = true, CoinESP = true,
    AutoGun = true, Aura = true, AutoShoot = true, AutoDodge = true,
    Noclip = false, Ghost = false, WaterProt = true, AntiFling = true,
    Fullbright = true
}

local flying = false
local flyBV, flyBG
local noclipConn, waterConn, ghostClone
local originalParts = {}

-- ============ HELPERS ============
local function getHRP() local c = LP.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = LP.Character return c and c:FindFirstChildOfClass("Humanoid") end

local function getRole(plr)
    if not plr or not plr.Character then return "Innocent" end
    if plr.Character:FindFirstChild("Knife") then return "Murderer" end
    if plr.Character:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function roleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 40, 40) end
    if role == "Sheriff" then return Color3.fromRGB(40, 140, 255) end
    return Color3.fromRGB(50, 255, 100)
end

-- ============ FULLBRIGHT ============
local function applyFullbright(on)
    if on then
        Lighting.Ambient = Color3.fromRGB(180,180,180)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e6
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.Brightness = 2
    end
end
if CFG.Fullbright then applyFullbright(true) end

-- ============ FLY ============
local function toggleFly()
    flying = not flying
    local hrp, hum = getHRP(), getHum()
    if not hrp or not hum then flying = false return end
    if flying then
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e5,1e5,1e5); flyBV.P = 1e4; flyBV.Parent = hrp
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5); flyBG.P = 1e4; flyBG.Parent = hrp
        hum.PlatformStand = true
    else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        hum.PlatformStand = false
    end
end

RunService.RenderStepped:Connect(function()
    if not flying then return end
    local hrp = getHRP() if not hrp then return end
    local dir = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
    if dir.Magnitude > 0 then dir = dir.Unit end
    flyBV.Velocity = dir * CFG.FlySpeed
    flyBG.CFrame = cam.CFrame
end)

-- ============ NOCLIP ============
local function setNoclip(on)
    CFG.Noclip = on
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            local c = LP.Character if not c then return end
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    if not originalParts[p] then originalParts[p] = p.CanCollide end
                    p.CanCollide = false
                end
            end
        end)
    else
        for p, v in pairs(originalParts) do
            if p.Parent and p:IsA("BasePart") then p.CanCollide = v end
        end
        originalParts = {}
    end
end

-- ============ GHOST ============
local function setGhost(on)
    CFG.Ghost = on
    if ghostClone then ghostClone:Destroy() ghostClone = nil end
    if on then
        local c = LP.Character if not c then return end
        c.Archivable = true
        ghostClone = c:Clone()
        ghostClone.Name = "Ghost_" .. LP.Name
        for _, p in ipairs(ghostClone:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false p.CanTouch = false p.CanQuery = false
                if p.Name ~= "HumanoidRootPart" then p.Transparency = 0.7 end
            end
        end
        local h = ghostClone:FindFirstChildOfClass("Humanoid")
        if h then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
        ghostClone.Parent = workspace
    end
end

-- ============ WATER PROT ============
local function setWaterProt(on)
    CFG.WaterProt = on
    if waterConn then waterConn:Disconnect() waterConn = nil end
    if on then
        waterConn = RunService.Heartbeat:Connect(function()
            local c = LP.Character if not c then return end
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanTouch = false end
            end
        end)
    end
end

-- ============ ANTIFLING ============
local function setAntiFling(on)
    CFG.AntiFling = on
    if on and getrawmetatable then
        local mt = getrawmetatable(game)
        if mt and mt.__namecall then
            local old = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local m = getnamecallmethod()
                if m == "SetNetworkOwner" and self == getHRP() then return end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end
end

-- ============ MOVEMENT ============
local function applyMovement()
    local h = getHum()
    if h then h.WalkSpeed = CFG.WalkSpeed h.JumpPower = CFG.JumpPower end
    if cam then cam.FieldOfView = CFG.FOV end
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    applyMovement()
    if CFG.Noclip then setNoclip(true) end
    if CFG.Ghost then setGhost(true) end
    if CFG.WaterProt then setWaterProt(true) end
end)

-- ============ ESP ============
local espFolder = Instance.new("Folder", game:GetService("CoreGui"))
espFolder.Name = "MM2_DOM_ESP"
local espData = {}

local function makeESP(plr)
    if plr == LP or espData[plr] then return end
    local hl = Instance.new("Highlight")
    hl.Name = plr.Name
    hl.FillColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(0,0,0)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = espFolder
    local bb = Instance.new("BillboardGui")
    bb.Name = plr.Name.."_txt"
    bb.Size = UDim2.new(0, 200, 0, 40)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.Parent = espFolder
    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
    txt.TextStrokeTransparency = 0
    txt.TextColor3 = Color3.new(1,1,1)
    espData[plr] = {hl = hl, bb = bb, txt = txt}
end

for _, p in ipairs(Players:GetPlayers()) do makeESP(p) end
Players.PlayerAdded:Connect(makeESP)

RunService.RenderStepped:Connect(function()
    for plr, d in pairs(espData) do
        if not plr.Parent then
            if d.hl then d.hl:Destroy() end
            if d.bb then d.bb:Destroy() end
            espData[plr] = nil
            continue
        end
        local c = plr.Character
        local head = c and c:FindFirstChild("Head")
        local role = getRole(plr)
        local col = roleColor(role)
        if head and d.hl then
            d.hl.Adornee = c
            d.hl.FillColor = col
            d.bb.Adornee = head
            d.txt.Text = plr.Name .. "  [" .. role .. "]"
            d.txt.TextColor3 = col
            d.hl.Enabled = CFG.ESP
            d.bb.Enabled = CFG.ESP
        end
    end
end)

-- ============ GUN ESP ============
local gunFolder = Instance.new("Folder", game:GetService("CoreGui"))
gunFolder.Name = "MM2_DOM_GUN"
RunService.Heartbeat:Connect(function()
    if not CFG.GunESP then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj:IsA("BasePart") and not gunFolder:FindFirstChild(tostring(obj:GetDebugId())) then
            local hl = Instance.new("Highlight")
            hl.Name = tostring(obj:GetDebugId())
            hl.Adornee = obj
            hl.FillColor = Color3.fromRGB(255, 220, 0)
            hl.OutlineColor = Color3.fromRGB(255,255,255)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = gunFolder
            obj.AncestryChanged:Connect(function() if not obj.Parent then hl:Destroy() end end)
        end
    end
end)

-- ============ COIN ESP ============
RunService.Heartbeat:Connect(function()
    if not CFG.CoinESP then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Coin" and obj:IsA("BasePart") and not obj:FindFirstChild("CoinHL") then
            local hl = Instance.new("Highlight")
            hl.Name = "CoinHL"; hl.Adornee = obj
            hl.FillColor = Color3.fromRGB(255, 215, 0)
            hl.FillTransparency = 0.3
            hl.OutlineColor = Color3.fromRGB(255,255,150)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = obj
        end
    end
end)

-- ============ AUTO PICKUP GUN ============
task.spawn(function()
    while task.wait(0.3) do
        if not CFG.AutoGun then continue end
        local hrp = getHRP() if not hrp then continue end
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "Gun" or obj.Name == "GunDrop" then
                local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and obj.PrimaryPart) or obj:FindFirstChildWhichIsA("BasePart")
                if part and firetouchinterest then
                    pcall(firetouchinterest, hrp, part, 0)
                    pcall(firetouchinterest, hrp, part, 1)
                end
            end
        end
    end
end)

-- ============ KILL AURA ============
RunService.Heartbeat:Connect(function()
    if not CFG.Aura then return end
    local c = LP.Character if not c then return end
    local knife = c:FindFirstChild("Knife") if not knife then return end
    local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP or not plr.Character then continue end
        local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if thrp and (thrp.Position - hrp.Position).Magnitude < CFG.AuraRange then
            pcall(function() knife:Activate() end)
        end
    end
end)

-- ============ AUTO SHOOT ============
RunService.Heartbeat:Connect(function()
    if not CFG.AutoShoot then return end
    local c = LP.Character if not c then return end
    local gun = c:FindFirstChild("Gun") or (LP.Backpack and LP.Backpack:FindFirstChild("Gun"))
    if not gun then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP or not plr.Character then continue end
        if plr.Character:FindFirstChild("Knife") then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if thrp then
                cam.CFrame = CFrame.new(cam.CFrame.Position, thrp.Position)
                pcall(function() gun:Activate() end)
            end
        end
    end
end)

-- ============ AUTO DODGE ============
RunService.Heartbeat:Connect(function()
    if not CFG.AutoDodge then return end
    local hrp = getHRP() if not hrp then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP or not plr.Character then continue end
        if plr.Character:FindFirstChild("Knife") then
            local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if thrp and (thrp.Position - hrp.Position).Magnitude < 30 then
                local away = (hrp.Position - thrp.Position).Unit
                hrp.CFrame = hrp.CFrame + away * 0.5
            end
        end
    end
end)

-- ============ TP ============
local function tpTo(plr)
    local hrp = getHRP()
    if not hrp or not plr or not plr.Character then return end
    local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if thrp then hrp.CFrame = thrp.CFrame * CFrame.new(0,0,3) end
end

-- ============ UI TABS ============
local T1 = Window:CreateTab("Movement", nil)
T1:CreateToggle({ Name = "Fly (WASD + Space/Ctrl)", CurrentValue = false, Callback = toggleFly })
T1:CreateSlider({ Name = "Fly Speed", Range = {10, 500}, Increment = 5, CurrentValue = CFG.FlySpeed, Callback = function(v) CFG.FlySpeed = v end })
T1:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = setNoclip })
T1:CreateToggle({ Name = "Ghost Mode", CurrentValue = false, Callback = setGhost })
T1:CreateSlider({ Name = "WalkSpeed", Range = {16, 300}, Increment = 1, CurrentValue = CFG.WalkSpeed, Callback = function(v) CFG.WalkSpeed = v applyMovement() end })
T1:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 5, CurrentValue = CFG.JumpPower, Callback = function(v) CFG.JumpPower = v applyMovement() end })
T1:CreateSlider({ Name = "FOV", Range = {70, 160}, Increment = 1, CurrentValue = CFG.FOV, Callback = function(v) CFG.FOV = v applyMovement() end })

local T2 = Window:CreateTab("ESP", nil)
T2:CreateToggle({ Name = "Player ESP + Roles", CurrentValue = true, Callback = function(v) CFG.ESP = v end })
T2:CreateToggle({ Name = "Gun Drop ESP", CurrentValue = true, Callback = function(v) CFG.GunESP = v end })
T2:CreateToggle({ Name = "Coin ESP", CurrentValue = true, Callback = function(v) CFG.CoinESP = v end })

local T3 = Window:CreateTab("Combat", nil)
T3:CreateToggle({ Name = "Kill Aura (нужен нож)", CurrentValue = true, Callback = function(v) CFG.Aura = v end })
T3:CreateSlider({ Name = "Aura Range", Range = {5, 60}, Increment = 1, CurrentValue = CFG.AuraRange, Callback = function(v) CFG.AuraRange = v end })
T3:CreateToggle({ Name = "Auto Shoot Murderer", CurrentValue = true, Callback = function(v) CFG.AutoShoot = v end })
T3:CreateToggle({ Name = "Auto Dodge", CurrentValue = true, Callback = function(v) CFG.AutoDodge = v end })
T3:CreateToggle({ Name = "Auto Pickup Gun", CurrentValue = true, Callback = function(v) CFG.AutoGun = v end })

local T4 = Window:CreateTab("Misc", nil)
T4:CreateToggle({ Name = "Water Protection", CurrentValue = true, Callback = setWaterProt })
T4:CreateToggle({ Name = "AntiFling", CurrentValue = true, Callback = setAntiFling })
T4:CreateToggle({ Name = "Fullbright", CurrentValue = true, Callback = applyFullbright })
T4:CreateButton({ Name = "Teleport to Murderer", Callback = function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Knife") then tpTo(p) return end
    end
end })
T4:CreateButton({ Name = "Teleport to Sheriff", Callback = function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Gun") then tpTo(p) return end
    end
end })

-- ============ HOTKEYS ============
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    local k = input.KeyCode
    if k == Enum.KeyCode.RightShift then toggleFly() end
    if k == Enum.KeyCode.X then setNoclip(not CFG.Noclip) end
    if k == Enum.KeyCode.G then setGhost(not CFG.Ghost) end
end)

-- ============ INIT ============
if LP.Character then applyMovement() end
if CFG.WaterProt then setWaterProt(true) end
if CFG.AntiFling then setAntiFling(true) end

Rayfield:Notify({
    Title = "MM2 DOMINATOR v3",
    Content = "Загружено! RightShift=Fly, X=Noclip, G=Ghost",
    Duration = 5
})
