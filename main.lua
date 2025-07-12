-- EzHub for Dead Rails
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "EzHubGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 300, 0, 320)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local layout = Instance.new("UIListLayout", Frame)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Toggle Button Creator
local function createToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Text = "[ OFF ] " .. name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.MouseButton1Click:Connect(function()
        local on = btn.Text:find("OFF") ~= nil
        btn.Text = on and "[ ON ] " .. name or "[ OFF ] " .. name
        callback(on)
    end)
    return btn
end

-- AUTO BOND
local autoBond = false
createToggle("Auto Bond", Frame, function(state)
    autoBond = state
end)

-- AUTO WIN
local autoWin = false
createToggle("Auto Win", Frame, function(state)
    autoWin = state
end)

-- AIMBOT
local aimEnabled = false
createToggle("Aimbot", Frame, function(state)
    aimEnabled = state
end)

-- ESP
local espEnabled = false
createToggle("ESP", Frame, function(state)
    espEnabled = state
end)

-- TELEPORT
createToggle("Teleport to Player", Frame, function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            break
        end
    end
end)

-- NOCLIP
local noclip = false
createToggle("NoClip", Frame, function(state)
    noclip = state
end)

-- TOGGLE UI
local toggleBtn = Instance.new("TextButton", ScreenGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Toggle Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 16
toggleBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- ESP Logic
local function createESP(part)
    local gui = Instance.new("BillboardGui", part)
    gui.Name = "EzHubESP"
    gui.Size = UDim2.new(0, 100, 0, 20)
    gui.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", gui)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Text = part.Parent.Name
    lbl.TextColor3 = Color3.new(1, 0, 0)
    lbl.BackgroundTransparency = 1
end

-- Loop Logic
RunService.Stepped:Connect(function()
    if autoBond then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "BondPart" then
                LocalPlayer.Character:MoveTo(v.Position)
            end
        end
    end

    if autoWin then
        local endPart = workspace:FindFirstChild("Finish") or workspace:FindFirstChild("EndZone")
        if endPart then
            LocalPlayer.Character:MoveTo(endPart.Position)
        end
    end

    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                if not plr.Character.Head:FindFirstChild("EzHubESP") then
                    createESP(plr.Character.Head)
                end
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local esp = plr.Character.Head:FindFirstChild("EzHubESP")
                if esp then esp:Destroy() end
            end
        end
    end
end)

-- Aimbot
RunService.RenderStepped:Connect(function()
    if aimEnabled then
        local mouse = LocalPlayer:GetMouse()
        local closest = nil
        local minDist = math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local pos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(player.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = player
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            mouse.TargetFilter = closest.Character
            mouse.Hit = CFrame.new(closest.Character.Head.Position)
        end
    end
end)
