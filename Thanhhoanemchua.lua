--[[ 
    SCRIPT ZERAA OVERLAY V6 - FINAL
    - File Save Name: "Zeraa_[Username].txt"
    - Workspace Data: Folder "ZeraaData"
    - Dual Fonts: 12187361943 (Text) & 12187362120 (Stats)
    - Accurate FPS & Time Tracking
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- == CẤU HÌNH FONT ==
-- Font 1: Zeraa, Username, Game, Time (Theo yêu cầu)
local TextFontID = "rbxassetid://12187361943"
local TextFont = Font.new(TextFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- Font 2: FPS, RAM, MS (Theo yêu cầu)
local NumberFontID = "rbxassetid://12187362120"
local NumberFont = Font.new(NumberFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- == HỆ THỐNG FILE SAVE (Zeraa_LocalPlayer.txt) ==
-- Tên file sẽ thay đổi theo tên người chơi để tránh lỗi khi đổi acc
local FileName = "Zeraa_" .. LocalPlayer.Name .. ".txt"

local SavedTotalTime = 0
local SessionStartTime = os.time()

-- 1. Đọc file cũ nếu tồn tại
if isfile and isfile(FileName) then
    local content = readfile(FileName)
    SavedTotalTime = tonumber(content) or 0
end

-- 2. Tạo Folder trong Workspace
local DataFolder = Workspace:FindFirstChild("ZeraaData")
if not DataFolder then
    DataFolder = Instance.new("Folder")
    DataFolder.Name = "ZeraaData"
    DataFolder.Parent = Workspace
end

-- Tạo các Value object để theo dõi
local SessionVal = DataFolder:FindFirstChild("SessionTime") or Instance.new("IntValue", DataFolder)
SessionVal.Name = "SessionTime"

local TotalVal = DataFolder:FindFirstChild("TotalTime") or Instance.new("IntValue", DataFolder)
TotalVal.Name = "TotalTime"
TotalVal.Value = SavedTotalTime

-- == GUI SETUP ==
if CoreGui:FindFirstChild("ZeraaScreenV6") then CoreGui.ZeraaScreenV6:Destroy() end
if Lighting:FindFirstChild("ZeraaBlurV6") then Lighting.ZeraaBlurV6:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZeraaScreenV6"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Hiệu ứng
local Blur = Instance.new("BlurEffect")
Blur.Name = "ZeraaBlurV6"
Blur.Size = 20
Blur.Parent = Lighting

local DimFrame = Instance.new("Frame")
DimFrame.Name = "DimLayer"
DimFrame.Size = UDim2.new(1, 0, 1, 0)
DimFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DimFrame.BackgroundTransparency = 0.6
DimFrame.Parent = ScreenGui

-- Layout Container
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0.9, 0, 0.9, 0)
MainContainer.Position = UDim2.new(0.05, 0, 0.05, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = ScreenGui

local UIList = Instance.new("UIListLayout")
UIList.Parent = MainContainer
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Center
UIList.Padding = UDim.new(0.02, 0)

-- Hàm tạo Label nhanh
local function CreateLabel(name, font, sizeY, color)
    local lab = Instance.new("TextLabel")
    lab.Name = name
    lab.Size = UDim2.new(1, 0, sizeY, 0)
    lab.TextColor3 = color
    lab.BackgroundTransparency = 1
    lab.TextScaled = true
    lab.FontFace = font
    lab.Parent = MainContainer
    
    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MaxTextSize = (name == "Title") and 130 or 50
    constraint.Parent = lab
    return lab
end

-- 1. Zeraa
local TitleLabel = CreateLabel("Title", TextFont, 0.2, Color3.fromRGB(135, 206, 250))
TitleLabel.Text = "Zeraa"

-- 2. Username
local UserLabel = CreateLabel("User", TextFont, 0.08, Color3.fromRGB(255, 255, 255))
UserLabel.Text = "Username: " .. LocalPlayer.Name

-- 3. Game Name
local GameLabel = CreateLabel("Game", TextFont, 0.12, Color3.fromRGB(255, 255, 255))
GameLabel.Text = "Game: Loading..."
task.spawn(function()
    local s, i = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if s and i then GameLabel.Text = "Game: " .. i.Name else GameLabel.Text = "Game: Unknown" end
end)

-- 4. Time & Total Time (Dùng Font Zeraa - TextFont)
local TimeLabel = CreateLabel("TimeInfo", TextFont, 0.10, Color3.fromRGB(255, 255, 255))
TimeLabel.Text = "Time: 00:00:00 | Total Time: 00:00:00"

-- 5. Stats FPS RAM MS (Dùng Font Số - NumberFont)
local StatsLabel = CreateLabel("Stats", NumberFont, 0.10, Color3.fromRGB(220, 220, 220))
StatsLabel.Text = "Calculating..."

-- == LOGIC LOOP ==
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
        
        -- A. FPS Calculation (Time Delta)
        local CurrentTime = os.clock()
        local TimeDiff = CurrentTime - LastTime
        local fps = math.floor(FrameCount / TimeDiff)
        FrameCount = 0
        LastTime = CurrentTime
        
        -- B. RAM & Ping
        local ram = math.floor(StatsService:GetTotalMemoryUsageMb())
        local ping = 0
        pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        
        -- C. Time Logic
        local CurrentSession = os.time() - SessionStartTime
        local CurrentTotal = SavedTotalTime + CurrentSession
        
        local TimeStr = FormatTime(CurrentSession)
        local TotalStr = FormatTime(CurrentTotal)
        
        -- D. Update Workspace & File
        if SessionVal then SessionVal.Value = CurrentSession end
        if TotalVal then TotalVal.Value = CurrentTotal end
        
        -- Lưu file mỗi giây (overwrite)
        if writefile then
            writefile(FileName, tostring(CurrentTotal))
        end

        -- E. Update UI
        -- Time dùng font chữ (Zeraa font)
        TimeLabel.Text = string.format("Time: %s  |  Total Time: %s", TimeStr, TotalStr)
        
        -- Stats dùng font số (Number font)
        StatsLabel.Text = string.format("FPS: %d  |  RAM: %d MB  |  ms: %d", fps, ram, ping)
    end
end)

print("Zeraa Script V6 Loaded. File saved as: " .. FileName)
