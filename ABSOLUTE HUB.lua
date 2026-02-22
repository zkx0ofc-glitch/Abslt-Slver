-- Absolute Solver Hub (Cyn Edition) - UNIVERSAL SCRIPTS 
-- Tecla de Atalho: F4

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
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
MainFrame.Parent = ScreenGui

-- BORDAS DUPLAS (FIEL À IMAGEM)
Instance.new("UIStroke", MainFrame).Thickness = 4
Instance.new("UIStroke", MainFrame).Color = Theme.Accent

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
StopLabel.Text = "ADMINISTRADOR"
StopLabel.TextColor3 = Theme.Accent
StopLabel.Font = Enum.Font.Code
StopLabel.TextSize = 55
StopLabel.BackgroundTransparency = 1

-----------------------------------------------------------
-- MOTORES DE COMANDO (SCRIPTS UNIVERSAIS)
-----------------------------------------------------------

local function AddCommand(name, desc, func)
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
        task.spawn(function()
            if active then 
                print("[SOLVER] Executing: " .. name)
                func(true) 
            else 
                func(false) 
            end
        end)
    end)
end

-----------------------------------------------------------
-- LISTA DE SCRIPTS UNIVERSAIS (FUNCIONAIS)
-----------------------------------------------------------

-- 1. VELOCIDADE ABSOLUTA
AddCommand("Speed Overclock", "Aumenta WalkSpeed", function(on)
    LocalPlayer.Character.Humanoid.WalkSpeed = on and 60 or 16
end)

-- 2. PULO GRAVITACIONAL
AddCommand("High Jump", "Aumenta JumpPower", function(on)
    LocalPlayer.Character.Humanoid.JumpPower = on and 100 or 50
    LocalPlayer.Character.Humanoid.UseJumpPower = true
end)

-- 3. VOAR (FLY) - MODO SIMPLES
local flying = false
local bv = nil
AddCommand("Solver Flight", "Habilita Voo", function(on)
    flying = on
    local char = LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if on and root then
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
        
        task.spawn(function()
            while flying do
                local dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                bv.Velocity = dir * 50
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    end
end)

-- 4. ESP PLAYERS (VISÃO DE DRONE)
local esp_folders = Instance.new("Folder", ScreenGui)
AddCommand("Drone Vision", "ESP Players", function(on)
    if on then
        RunService:BindToRenderStep("CynESP", 1, function()
            esp_folders:ClearAllChildren()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local box = Instance.new("BillboardGui", esp_folders)
                    box.Adornee = p.Character.Head
                    box.Size = UDim2.new(0, 100, 0, 50)
                    box.AlwaysOnTop = true
                    local label = Instance.new("TextLabel", box)
                    label.Size = UDim2.new(1,0,1,0)
                    label.Text = "[ " .. p.DisplayName .. " ]"
                    label.TextColor3 = Theme.Accent
                    label.BackgroundTransparency = 1
                    label.Font = Enum.Font.Code
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("CynESP")
        esp_folders:ClearAllChildren()
    end
end)

-- 5. NOCLIP (ATRAVESSAR PAREDES)
local noclip = false
AddCommand("Ghost Protocol", "NoClip", function(on)
    noclip = on
    RunService.Stepped:Connect(function()
        if noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-----------------------------------------------------------
-- SISTEMA DE GLITCH (ABRIR/FECHAR)
-----------------------------------------------------------
local IsMoving = false

local function GlitchEffect(showing)
    if IsMoving then return end
    IsMoving = true
    
    if showing then
        MainFrame.Visible = true
        -- Som de "bip" ou interferência pode ser simulado com flashes
        for i = 1, 6 do
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + math.random(-10, 10), startPos.Y.Scale, startPos.Y.Offset + math.random(-5, 5))
            MainFrame.BackgroundTransparency = math.random(1, 5) / 10
            Header.TextColor3 = (i % 2 == 0) and Color3.new(1, 1, 1) or Theme.Accent
            task.wait(0.03)
        end
        MainFrame.Position = startPos
        MainFrame.BackgroundTransparency = Theme.Transparent
        Header.TextColor3 = Theme.Accent
    else
        for i = 1, 6 do
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + math.random(-15, 15), startPos.Y.Scale, startPos.Y.Offset + math.random(-8, 8))
            MainFrame.BackgroundTransparency = i / 6
            task.wait(0.02)
        end
        MainFrame.Visible = false
    end
    
    IsMoving = false
end

-- Atualiza a posição inicial para o sistema de drag não quebrar o glitch
startPos = MainFrame.Position

-- TECLA F4 COM ANIMAÇÃO CYN
UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.F4 then
        local isCurrentlyVisible = MainFrame.Visible
        GlitchEffect(not isCurrentlyVisible)
    end
end)

-----------------------------------------------------------
-- AJUSTE NO SISTEMA DE ARRASTAR (DRAG)
-----------------------------------------------------------
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position -- Atualiza posição base para o glitch saber onde voltar
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragging = false 
        startPos = MainFrame.Position -- Fixa a nova posição após arrastar
    end 
end)

print("Absolute Solver Hub: Glitch Engine Active. [F4]")


