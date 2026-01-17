--[[ 
    SCRIPT ZERAA OVERLAY V4
    - Removed CPU
    - Hyper-Accurate FPS (Time Delta Calculation)
    - Dual Custom Fonts
]]

-- Dịch vụ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- == CẤU HÌNH FONT ==
-- Font cho Tiêu đề, Tên, Game
local HeaderFontID = "rbxassetid://12187361943"
local HeaderFont = Font.new(HeaderFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- Font cho Stats (FPS, RAM, ms) - THEO YÊU CẦU
local StatsFontID = "rbxassetid://12187362120"
local StatsFont = Font.new(StatsFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- 1. Dọn dẹp GUI cũ
if CoreGui:FindFirstChild("ZeraaScreenV4") then
    CoreGui.ZeraaScreenV4:Destroy()
end
if Lighting:FindFirstChild("ZeraaBlurV4") then
    Lighting.ZeraaBlurV4:Destroy()
end

-- 2. Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZeraaScreenV4"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

-- 3. Hiệu ứng Mờ và Tối
local Blur = Instance.new("BlurEffect")
Blur.Name = "ZeraaBlurV4"
Blur.Size = 20
Blur.Parent = Lighting

local DimFrame = Instance.new("Frame")
DimFrame.Name = "DimLayer"
DimFrame.Size = UDim2.new(1, 0, 1, 0)
DimFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DimFrame.BackgroundTransparency = 0.6 -- Tối 40%
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
UIList.Padding = UDim.new(0.03, 0) -- Khoảng cách thoáng hơn do bớt dòng CPU

-- == PHẦN 1: ZERAA ==
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "1_Title"
TitleLabel.Text = "Zeraa"
TitleLabel.Size = UDim2.new(1, 0, 0.25, 0)
TitleLabel.TextColor3 = Color3.fromRGB(135, 206, 250) -- Xanh biển nhạt
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextScaled = true
TitleLabel.FontFace = HeaderFont -- Font 12187361943
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
UserLabel.FontFace = HeaderFont -- Font 12187361943
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
GameLabel.FontFace = HeaderFont -- Font 12187361943
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

-- == PHẦN 4: STATS (FPS, RAM, MS) ==
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "4_Stats"
StatsLabel.Text = "Calculating..."
StatsLabel.Size = UDim2.new(1, 0, 0.15, 0)
StatsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextScaled = true
StatsLabel.FontFace = StatsFont -- FONT MỚI: 12187362120
StatsLabel.Parent = MainContainer

local StatsConstraint = Instance.new("UITextSizeConstraint")
StatsConstraint.MaxTextSize = 45 -- Size chữ vừa phải cho thông số
StatsConstraint.Parent = StatsLabel

-- 5. HỆ THỐNG ĐO FPS CHÍNH XÁC CAO
-- Biến hỗ trợ đo FPS
local FrameCount = 0
local LastTime = os.clock() -- Lấy thời gian chính xác hiện tại

-- Kết nối RenderStepped để đếm từng khung hình
RunService.RenderStepped:Connect(function()
    FrameCount = FrameCount + 1
end)

-- Vòng lặp cập nhật mỗi 1 giây
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(1) -- Chờ 1 giây
        
        -- Tính FPS dựa trên thời gian thực trôi qua (Delta Time)
        -- Công thức: Số frame / Thời gian trôi qua thực tế
        -- Cách này chính xác hơn việc chỉ đếm frame vì task.wait(1) không bao giờ là chuẩn 1.000s
        local CurrentTime = os.clock()
        local TimeDiff = CurrentTime - LastTime
        
        local fps = math.floor(FrameCount / TimeDiff)
        
        -- Reset bộ đếm
        FrameCount = 0
        LastTime = CurrentTime
        
        -- Lấy RAM
        local ram = math.floor(StatsService:GetTotalMemoryUsageMb())
        
        -- Lấy Ping
        local ping = 0
        pcall(function()
            ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)

        -- Cập nhật Text với Font mới
        StatsLabel.Text = string.format("FPS: %d  |  RAM: %d MB  |  ms: %d", fps, ram, ping)
    end
end)

print("Zeraa V4: No CPU, Accurate FPS, Custom Stats Font Loaded.")
