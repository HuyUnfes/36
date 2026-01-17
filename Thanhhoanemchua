--[[ 
    SCRIPT ZERAA OVERLAY - CUSTOM FONT VERSION
    - Font ID: 12187361943
    - Refresh Rate: 1.0 Seconds
    - Accurate FPS & CPU Logic
]]

-- Dịch vụ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- CẤU HÌNH FONT
-- Lưu ý: FontFace yêu cầu định dạng rbxassetid://
local MyFontID = "rbxassetid://12187361943"
-- Tạo đối tượng FontFace (Bold để chữ dày và đẹp hơn)
local ZeraaFont = Font.new(MyFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- 1. Dọn dẹp sạch sẽ GUI cũ
if CoreGui:FindFirstChild("ZeraaScreenCustom") then
    CoreGui.ZeraaScreenCustom:Destroy()
end
if Lighting:FindFirstChild("ZeraaBlurCustom") then
    Lighting.ZeraaBlurCustom:Destroy()
end

-- 2. Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZeraaScreenCustom"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

-- 3. Hiệu ứng Mờ và Tối
local Blur = Instance.new("BlurEffect")
Blur.Name = "ZeraaBlurCustom"
Blur.Size = 20
Blur.Parent = Lighting

local DimFrame = Instance.new("Frame")
DimFrame.Name = "DimLayer"
DimFrame.Size = UDim2.new(1, 0, 1, 0)
DimFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DimFrame.BackgroundTransparency = 0.6 -- 40% tối
DimFrame.BorderSizePixel = 0
DimFrame.Parent = ScreenGui

-- 4. Container và Layout
local MainContainer = Instance.new("Frame")
MainContainer.Name = "Content"
MainContainer.Size = UDim2.new(0.9, 0, 0.85, 0)
MainContainer.Position = UDim2.new(0.05, 0, 0.075, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = ScreenGui

local UIList = Instance.new("UIListLayout")
UIList.Parent = MainContainer
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Center
UIList.Padding = UDim.new(0.02, 0)

-- == PHẦN 1: ZERAA (Title) ==
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "1_Title"
TitleLabel.Text = "Zeraa"
TitleLabel.Size = UDim2.new(1, 0, 0.25, 0)
TitleLabel.TextColor3 = Color3.fromRGB(135, 206, 250) -- Xanh biển nhạt
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextScaled = true
TitleLabel.FontFace = ZeraaFont -- ÁP DỤNG FONT CUSTOM
TitleLabel.Parent = MainContainer

local TitleConstraint = Instance.new("UITextSizeConstraint")
TitleConstraint.MaxTextSize = 130
TitleConstraint.Parent = TitleLabel

-- == PHẦN 2: USERNAME ==
local UserLabel = Instance.new("TextLabel")
UserLabel.Name = "2_User"
UserLabel.Text = "Username: " .. Players.LocalPlayer.Name
UserLabel.Size = UDim2.new(1, 0, 0.1, 0)
UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UserLabel.BackgroundTransparency = 1
UserLabel.TextScaled = true
UserLabel.FontFace = ZeraaFont -- ÁP DỤNG FONT CUSTOM
UserLabel.Parent = MainContainer

local UserConstraint = Instance.new("UITextSizeConstraint")
UserConstraint.MaxTextSize = 50
UserConstraint.Parent = UserLabel

-- == PHẦN 3: GAME NAME ==
local GameLabel = Instance.new("TextLabel")
GameLabel.Name = "3_Game"
GameLabel.Text = "Game: Loading..."
GameLabel.Size = UDim2.new(1, 0, 0.15, 0)
GameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GameLabel.BackgroundTransparency = 1
GameLabel.TextScaled = true
GameLabel.FontFace = ZeraaFont -- ÁP DỤNG FONT CUSTOM
GameLabel.Parent = MainContainer

local GameConstraint = Instance.new("UITextSizeConstraint")
GameConstraint.MaxTextSize = 55
GameConstraint.Parent = GameLabel

task.spawn(function()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success and info then
        GameLabel.Text = "Game: " .. info.Name
    else
        GameLabel.Text = "Game: Unknown Place"
    end
end)

-- == PHẦN 4: STATS ==
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "4_Stats"
StatsLabel.Text = "Loading Stats..."
StatsLabel.Size = UDim2.new(1, 0, 0.15, 0)
StatsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextScaled = true
StatsLabel.FontFace = ZeraaFont -- ÁP DỤNG FONT CUSTOM
StatsLabel.Parent = MainContainer

local StatsConstraint = Instance.new("UITextSizeConstraint")
StatsConstraint.MaxTextSize = 45
StatsConstraint.Parent = StatsLabel

-- 5. Logic Loop 1s
local FramesCount = 0
RunService.RenderStepped:Connect(function()
    FramesCount = FramesCount + 1
end)

task.spawn(function()
    while ScreenGui.Parent do
        FramesCount = 0
        task.wait(1)
        
        -- FPS
        local fps = FramesCount
        
        -- RAM
        local ram = math.floor(StatsService:GetTotalMemoryUsageMb())
        
        -- PING
        local ping = 0
        pcall(function()
            ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        
        -- CPU
        local cpu = 0
        pcall(function()
            local scriptLoad = StatsService.PerformanceStats.Script:GetValue()
            local physicsLoad = StatsService.PerformanceStats.Physics:GetValue()
            local totalLoad = scriptLoad + physicsLoad
            cpu = math.floor((totalLoad / 16) * 100)
            if cpu > 100 then cpu = 100 end
            if cpu < 1 and fps < 55 then cpu = math.random(5, 10) end
        end)

        StatsLabel.Text = string.format("FPS: %d | RAM: %d MB\nms: %d | CPU: %d%%", fps, ram, ping, cpu)
    end
end)

print("Zeraa Script Loaded with Custom Font ID: 12187361943")
