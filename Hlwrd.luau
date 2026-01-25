--[[ 
    BLOX FRUITS TWEEN SCRIPT (ANTI-CHEAT BYPASS)
    Target: Clock Position (29555, 15069, -393)
    Speed: 300
    Features: Draggable GUI, Tween, Anti-Kick Physics, Auto Haki
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- --- CẤU HÌNH ---
local TARGET_POSITION = Vector3.new(29555, 15069, -393) -- Tọa độ Đồng hồ
local TWEEN_SPEED = 300 -- Tốc độ an toàn cho Blox Fruits (300-350)

-- --- TẠO GUI (MENU DI CHUYỂN) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local TeleportButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "BloxFruitsTween"
ScreenGui.ResetOnSpawn = false -- Giữ GUI khi chết

-- Anti-Detection cho GUI (Parent vào CoreGui nếu có thể)
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 140)
MainFrame.Active = true
MainFrame.Draggable = true -- CHO PHÉP KÉO THẢ

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Tiêu đề
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TitleLabel.Size = UDim2.new(1, 0, 0.25, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "BLOX FRUITS TWEEN"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16.000

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

-- Nút Bay
TeleportButton.Parent = MainFrame
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
TeleportButton.Position = UDim2.new(0.1, 0, 0.35, 0)
TeleportButton.Size = UDim2.new(0.8, 0, 0.35, 0)
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.Text = "ĐẾN ĐỒNG HỒ"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 18.000

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = TeleportButton

-- Trạng thái
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0.2, 0)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Trạng thái: Đứng yên"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12.000

-- --- XỬ LÝ ANTI-CHEAT & TWEEN ---

local currentTween = nil
local physicsLoop = nil

-- Hàm bật Haki (Để bảo vệ)
local function AutoHaki()
    if not LocalPlayer.Character then return end
    local HakiKey = Enum.KeyCode.J -- Phím tắt mặc định Haki
    -- Kiểm tra xem có Haki chưa (thường check visual effect, ở đây spam phím J nhẹ nhàng)
    if not LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, HakiKey, false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, HakiKey, false, game)
    end
end

-- Hàm xử lý vật lý (Anti-Kick)
local function EnableBypass(state)
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end

    if state then
        -- Bật Bypass
        physicsLoop = RunService.Stepped:Connect(function()
            local hum = Character:FindFirstChild("Humanoid")
            local root = Character:FindFirstChild("HumanoidRootPart")
            
            if root and hum then
                -- 1. Giữ vận tốc bằng 0 để server không thấy nhân vật rơi tự do
                root.Velocity = Vector3.new(0, 0, 0)
                root.RotVelocity = Vector3.new(0, 0, 0)
                
                -- 2. Tắt va chạm (Noclip)
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
                
                -- 3. Đặt trạng thái PlatformStand để không bị animation làm phiền
                hum.PlatformStand = true
                hum.Sit = false -- Không cho ngồi ghế
            end
        end)
    else
        -- Tắt Bypass
        if physicsLoop then
            physicsLoop:Disconnect()
            physicsLoop = nil
        end
        
        local hum = Character:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
        
        -- Reset lại vận tốc 1 lần cuối
        if Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end

-- Anti-AFK (Tránh bị kick khi treo máy bay lâu)
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Chức năng nút bấm
TeleportButton.MouseButton1Click:Connect(function()
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if not RootPart then return end

    -- Logic Bật/Tắt
    if currentTween then
        -- DỪNG LẠI
        currentTween:Cancel()
        currentTween = nil
        EnableBypass(false)
        
        TeleportButton.Text = "ĐẾN ĐỒNG HỒ"
        TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        StatusLabel.Text = "Đã dừng bay."
        return
    end

    -- BẮT ĐẦU BAY
    AutoHaki() -- Bật Haki trước khi bay
    
    local Distance = (TARGET_POSITION - RootPart.Position).Magnitude
    local Time = Distance / TWEEN_SPEED
    
    StatusLabel.Text = "Khoảng cách: " .. math.floor(Distance) .. " | Thời gian: " .. math.floor(Time) .. "s"
    
    local TweenInfoData = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    currentTween = TweenService:Create(RootPart, TweenInfoData, {CFrame = CFrame.new(TARGET_POSITION)})
    
    -- Setup giao diện khi đang bay
    TeleportButton.Text = "DỪNG LẠI"
    TeleportButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    EnableBypass(true) -- Bật chế độ chống kick/xuyên tường
    currentTween:Play()
    
    -- Khi bay xong
    currentTween.Completed:Connect(function()
        currentTween = nil
        EnableBypass(false) -- Tắt chế độ chống kick
        
        TeleportButton.Text = "ĐẾN ĐỒNG HỒ"
        TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        StatusLabel.Text = "Đã đến đích!"
    end)
end)
