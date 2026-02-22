-- Absolute Solver Hub (Cyn Edition) - FULL INTEGRATED
-- Tecla de Atalho: F4
-- Estilo: Murder Drones (CYN)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- PROTEÇÃO PARA EXECUTORES
if _G.CynSolverLoaded then return end
_G.CynSolverLoaded = true

-- PALETA DE CORES CYN (AMARELO TERMINAL)
local Theme = {
    Background = Color3.fromRGB(10, 10, 10),
    Accent = Color3.fromRGB(255, 230, 50),
    Text = Color3.fromRGB(255, 230, 50),
    Transparent = 0.1
}

-- GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CynSolverHub"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = Theme.Transparent
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- BORDAS DUPLAS (FIEL À IMAGEM)
local OuterStroke = Instance.new("UIStroke", MainFrame)
OuterStroke.Thickness = 4
OuterStroke.Color = Theme.Accent

local InnerLine = Instance.new("Frame", MainFrame)
InnerLine.Size = UDim2.new(1, -12, 1, -12)
InnerLine.Position = UDim2.new(0, 6, 0, 6)
InnerLine.BackgroundTransparency = 1
local InnerStroke = Instance.new("UIStroke", InnerLine)
InnerStroke.Thickness = 1
InnerStroke.Color = Theme.Accent

-- HEADER: SYS://MSNGR
local Header = Instance.new("TextLabel", MainFrame)
Header.Size = UDim2.new(1, -20, 0, 40)
Header.Position = UDim2.new(0, 15, 0, 5)
Header.Text = "SYS://MSNGR"
Header.TextColor3 = Theme.Accent
Header.Font = Enum.Font.Code
Header.TextSize = 22
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.BackgroundTransparency = 1

local Divider = Instance.new("Frame", MainFrame)
Divider.Size = UDim2.new(1, -20, 0, 2)
Divider.Position = UDim2.new(0, 10, 0, 45)
Divider.BackgroundColor3 = Theme.Accent
Divider.BorderSizePixel = 0

-- CONTAINER DE COMANDOS
local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Size = UDim2.new(1, -40, 1, -130)
Content.Position = UDim2.new(0, 20, 0, 60)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = Theme.Accent
local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 8)

-- STOP :)
local StopLabel = Instance.new("TextLabel", MainFrame)
StopLabel.Size = UDim2.new(1, 0, 0, 60)
StopLabel.Position = UDim2.new(0, 0, 1, -70)
StopLabel.Text = "STOP :)"
StopLabel.TextColor3 = Theme.Accent
StopLabel.Font = Enum.Font.Code
StopLabel.TextSize = 55
StopLabel.BackgroundTransparency = 1

-----------------------------------------------------------
-- SISTEMA DE GLITCH (ABRIR/FECHAR)
-----------------------------------------------------------
local IsMoving = false
local currentStartPos = MainFrame.Position

local function PlayGlitch(showing)
    if IsMoving then return end
    IsMoving = true
    
    if showing then
        MainFrame.Visible = true
        for i = 1, 8 do
            MainFrame.Position = UDim2.new(currentStartPos.X.Scale, currentStartPos.X.Offset + math.random(-12, 12), currentStartPos.Y.Scale, currentStartPos.Y.Offset + math.random(-6, 6))
            MainFrame.BackgroundTransparency = math.random(1, 4) / 10
            Header.TextColor3 = (i % 2 == 0) and Color3.new(1, 1, 1) or Theme.Accent
            task.wait(0.02)
        end
        MainFrame.Position = currentStartPos
        MainFrame.BackgroundTransparency = Theme.Transparent
        Header.TextColor3 = Theme.Accent
    else
        for i = 1, 8 do
            MainFrame.Position = UDim2.new(currentStartPos.X.Scale, currentStartPos.X.Offset + math.random(-15, 15), currentStartPos.Y.Scale, currentStartPos.Y.Offset + math.random(-10, 10))
            MainFrame.BackgroundTransparency = i / 8
            task.wait(0.02)
        end
        MainFrame.Visible = false
    end
    IsMoving = false
end

-----------------------------------------------------------
-- MOTOR DE COMANDOS (BOTÕES)
-----------------------------------------------------------
local function AddCommand(name, func)
    local active = false
    local Btn = Instance.new("TextButton", Content)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundTransparency = 1
    Btn.Text = "> MESSAGE FROM USER: \"" .. name:upper() .. "\""
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 15
    Btn.TextXAlignment = Enum.TextXAlignment.Left

    Btn.MouseButton1Click:Connect(function()
        active = not active
        Btn.TextColor3 = active and Color3.new(1,1,1) or Theme.Text
        task.spawn(function() func(active) end)
    end)
end

-----------------------------------------------------------
-- SCRIPTS UNIVERSAIS INTEGRADOS
-----------------------------------------------------------

AddCommand("Speed Overclock", function(on)
    LocalPlayer.Character.Humanoid.WalkSpeed = on and 60 or 16
end)

AddCommand("High Jump", function(on)
    LocalPlayer.Character.Humanoid.JumpPower = on and 100 or 50
    LocalPlayer.Character.Humanoid.UseJumpPower = true
end)

local flying = false
local bv = nil
AddCommand("Solver Flight", function(on)
    flying = on
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if on and root then
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flying do
                local dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                bv.Velocity = dir * 60
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    end
end)

local noclip = false
AddCommand("Ghost Protocol", function(on)
    noclip = on
    RunService.Stepped:Connect(function()
        if noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

local esp_folder = Instance.new("Folder", ScreenGui)
AddCommand("Drone Vision", function(on)
    if on then
        RunService:BindToRenderStep("CynESP", 1, function()
            esp_folder:ClearAllChildren()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local b = Instance.new("BillboardGui", esp_folder)
                    b.Adornee = p.Character.Head
                    b.Size = UDim2.new(0, 100, 0, 50)
                    b.AlwaysOnTop = true
                    local l = Instance.new("TextLabel", b)
                    l.Size = UDim2.new(1,0,1,0)
                    l.Text = "[ " .. p.DisplayName .. " ]"
                    l.TextColor3 = Theme.Accent
                    l.Font = Enum.Font.Code
                    l.BackgroundTransparency = 1
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("CynESP")
        esp_folder:ClearAllChildren()
    end
end)

-----------------------------------------------------------
-- ARRASTAR (DRAG) & ATALHO F4
-----------------------------------------------------------
local dragging, dragStart
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        currentStartPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(currentStartPos.X.Scale, currentStartPos.X.Offset + delta.X, currentStartPos.Y.Scale, currentStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragging = false 
        currentStartPos = MainFrame.Position
    end 
end)

UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.F4 then
        PlayGlitch(not MainFrame.Visible)
    end
end)

print("Absolute Solver: System Override Successful. [F4]")
