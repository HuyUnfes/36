--[[ 
    SCRIPT ZERAA OVERLAY V7 - FINAL NOTIFICATION VER
    - Font Stats: 12187368317
    - Notification: Zeraa/BNN Hub
    - File Save: "Zeraa_[Username].txt"
    - Accurate FPS & Time Tracking
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- == 1. CẤU HÌNH FONT ==
-- Font A: Zeraa, User, Game, Time (Font chữ)
local TextFontID = "rbxassetid://12187361943"
local TextFont = Font.new(TextFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- Font B: FPS, RAM, MS (Font số mới theo yêu cầu)
local NumberFontID = "rbxassetid://12187368317"
local NumberFont = Font.new(NumberFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- == 2. HỆ THỐNG LƯU TRỮ (FILE & WORKSPACE) ==
local FileName = "Zeraa_" .. LocalPlayer.Name .. ".txt"
local SavedTotalTime = 0
local SessionStartTime = os.time()

-- Đọc file cũ
if isfile and isfile(FileName) then
    local content = readfile(FileName)
    SavedTotalTime = tonumber(content) or 0
end

-- Tạo Folder Workspace
local DataFolder = Workspace:FindFirstChild("ZeraaData")
if not DataFolder then
    DataFolder = Instance.new("Folder")
    DataFolder.Name = "ZeraaData"
    DataFolder.Parent = Workspace
end

local SessionVal = DataFolder:FindFirstChild("SessionTime") or Instance.new("IntValue", DataFolder)
SessionVal.Name = "SessionTime"

local TotalVal = DataFolder:FindFirstChild("TotalTime") or Instance.new("IntValue", DataFolder)
TotalVal.Name = "TotalTime"
TotalVal.Value = SavedTotalTime

-- == 3. GIAO DIỆN (GUI) ==
if CoreGui:FindFirstChild("ZeraaScreenV7") then CoreGui.ZeraaScreenV7:Destroy() end
if Lighting:FindFirstChild("ZeraaBlurV7") then Lighting.ZeraaBlurV7:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZeraaScreenV7"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Hiệu ứng nền
local Blur = Instance.new("BlurEffect")
Blur.Name = "ZeraaBlurV7"
Blur.Size = 20
Blur.Parent = Lighting

local DimFrame = Instance.new("Frame")
DimFrame.Name = "DimLayer"
DimFrame.Size = UDim2.new(1, 0, 1, 0)
DimFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DimFrame.BackgroundTransparency = 0.6 -- Tối 40%
DimFrame.Parent = ScreenGui

-- Container chính (Căn giữa)
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0.9, 0, 0.85, 0)
MainContainer.Position = UDim2.new(0.05, 0, 0.075, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = ScreenGui

local UIList = Instance.new("UIListLayout")
UIList.Parent = MainContainer
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Center
UIList.Padding = UDim.new(0.02, 0) -- Khoảng cách giữa các dòng

-- Hàm tạo Label nhanh
local function CreateLabel(name, font, sizeY, color, order)
    local lab = Instance.new("TextLabel")
    lab.Name = name
    lab.LayoutOrder = order -- Đảm bảo thứ tự hiển thị
    lab.Size = UDim2.new(1, 0, sizeY, 0)
    lab.TextColor3 = color
    lab.BackgroundTransparency = 1
    lab.TextScaled = true
    lab.FontFace = font
    lab.Parent = MainContainer
    
    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MaxTextSize = (name == "1_Title") and 140 or 50 -- Chữ Zeraa to hơn hẳn
    constraint.Parent = lab
    return lab
end

-- A. ZERAA (TO NHẤT - Ở TRÊN CÙNG)
local TitleLabel = CreateLabel("1_Title", TextFont, 0.25, Color3.fromRGB(135, 206, 250), 1)
TitleLabel.Text = "Zeraa"

-- B. User
local UserLabel = CreateLabel("2_User", TextFont, 0.08, Color3.fromRGB(255, 255, 255), 2)
UserLabel.Text = "Username: " .. LocalPlayer.Name

-- C. Game
local GameLabel = CreateLabel("3_Game", TextFont, 0.12, Color3.fromRGB(255, 255, 255), 3)
GameLabel.Text = "Game: Loading..."
task.spawn(function()
    local s, i = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if s and i then GameLabel.Text = "Game: " .. i.Name else GameLabel.Text = "Game: Unknown" end
end)

-- D. Time (Dùng Font cũ)
local TimeLabel = CreateLabel("4_Time", TextFont, 0.10, Color3.fromRGB(255, 255, 255), 4)
TimeLabel.Text = "Time: 00:00:00 | Total Time: 00:00:00"

-- E. Stats (Dùng Font MỚI: 12187368317)
local StatsLabel = CreateLabel("5_Stats", NumberFont, 0.12, Color3.fromRGB(220, 220, 220), 5)
StatsLabel.Text = "Calculating..."


-- == 4. GỬI THÔNG BÁO (NOTIFICATION) ==
task.spawn(function()
    -- Đợi 1 chút để chắc chắn game đã load core
    task.wait(1)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Zeraa/BNN Hub",
            Text = "Banana Cat Hub discord.gg/chuoihub",
            Duration = 10, -- Hiển thị trong 10 giây
            -- Icon = "rbxassetid://..." (Nếu bạn có icon thì điền vào đây)
        })
    end)
end)


-- == 5. LOGIC LOOP ==
local function FormatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local FrameCount = 0
local LastTime = os.clock()

RunService.RenderStepped:Connect(function() FrameCount = FrameCount + 1 end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(1)
        
        -- Tính FPS
        local CurrentTime = os.clock()
        local TimeDiff = CurrentTime - LastTime
        local fps = math.floor(FrameCount / TimeDiff)
        FrameCount = 0
        LastTime = CurrentTime
        
        -- Tính RAM & Ping
        local ram = math.floor(StatsService:GetTotalMemoryUsageMb())
        local ping = 0
        pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        
        -- Tính Time
        local CurrentSession = os.time() - SessionStartTime
        local CurrentTotal = SavedTotalTime + CurrentSession
        
        -- Update Value
        if SessionVal then SessionVal.Value = CurrentSession end
        if TotalVal then TotalVal.Value = CurrentTotal end
        
        -- Lưu file
        if writefile then
            writefile(FileName, tostring(CurrentTotal))
        end

        -- Update UI
        TimeLabel.Text = string.format("Time: %s  |  Total Time: %s", FormatTime(CurrentSession), FormatTime(CurrentTotal))
        
        -- Stats với Font mới
        StatsLabel.Text = string.format("FPS: %d  |  RAM: %d MB  |  ms: %d", fps, ram, ping)
    end
end)

print("Zeraa V7 Loaded: Notification Sent & Stats Font Updated")
