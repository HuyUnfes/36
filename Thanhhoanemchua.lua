--[[ 
    SCRIPT ZERAA HUB V9 - ULTIMATE EDITION
    - Features: Overlay (RGB, Draggable), Time Save, Webhook, Server Hop, Join Job ID, Spam Join
    - Fonts: 12187361943 (Text) & 12187368317 (Stats)
    - Keybinds: 
        [Right Ctrl]: Hide/Show Overlay
        [Right Alt]:  Open/Close Utility Menu
]]

-- == CẤU HÌNH USER (SỬA Ở ĐÂY) ==
local WebhookURL = "" -- Dán link Webhook Discord của bạn vào đây (Nếu muốn dùng tính năng gửi báo cáo)
local ToggleOverlayKey = Enum.KeyCode.RightControl
local ToggleMenuKey = Enum.KeyCode.RightAlt

-- == DỊCH VỤ ==
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local RequestFunc = http_request or request or HttpPost or syn.request

-- == FONT SETUP ==
local TextFontID = "rbxassetid://12187361943" -- Font Zeraa
local TextFont = Font.new(TextFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local NumberFontID = "rbxassetid://12187368317" -- Font Stats
local NumberFont = Font.new(NumberFontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- == ANTI-AFK ==
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- == HỆ THỐNG FILE SAVE ==
local FileName = "Zeraa_" .. LocalPlayer.Name .. ".txt"
local SavedTotalTime = 0
local SessionStartTime = os.time()

if isfile and isfile(FileName) then
    local content = readfile(FileName)
    SavedTotalTime = tonumber(content) or 0
end

local DataFolder = Workspace:FindFirstChild("ZeraaData") or Instance.new("Folder", Workspace)
DataFolder.Name = "ZeraaData"
local SessionVal = DataFolder:FindFirstChild("SessionTime") or Instance.new("IntValue", DataFolder)
SessionVal.Name = "SessionTime"
local TotalVal = DataFolder:FindFirstChild("TotalTime") or Instance.new("IntValue", DataFolder)
TotalVal.Name = "TotalTime"
TotalVal.Value = SavedTotalTime

-- == GUI SETUP ==
if CoreGui:FindFirstChild("ZeraaHubV9") then CoreGui.ZeraaHubV9:Destroy() end
if Lighting:FindFirstChild("ZeraaBlurV9") then Lighting.ZeraaBlurV9:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZeraaHubV9"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Hiệu ứng nền (Blur & Dim)
local Blur = Instance.new("BlurEffect")
Blur.Name = "ZeraaBlurV9"
Blur.Size = 20
Blur.Parent = Lighting

local DimFrame = Instance.new("Frame")
DimFrame.Name = "DimLayer"
DimFrame.Size = UDim2.new(1, 0, 1, 0)
DimFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DimFrame.BackgroundTransparency = 0.6
DimFrame.Parent = ScreenGui

-- ====================================================
-- PHẦN 1: OVERLAY (INFO PANEL) - DRAGGABLE
-- ====================================================
local OverlayFrame = Instance.new("Frame")
OverlayFrame.Name = "OverlayFrame"
OverlayFrame.Size = UDim2.new(0.4, 0, 0.4, 0) -- Khung chứa
OverlayFrame.Position = UDim2.new(0.3, 0, 0.1, 0) -- Vị trí ban đầu
OverlayFrame.BackgroundTransparency = 1
OverlayFrame.Parent = ScreenGui

-- Kéo thả logic
local dragging, dragInput, dragStart, startPos
local function UpdateDrag(input)
    local delta = input.Position - dragStart
    OverlayFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
OverlayFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = OverlayFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
OverlayFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then UpdateDrag(input) end
end)

-- Layout cho Overlay
local UIList = Instance.new("UIListLayout")
UIList.Parent = OverlayFrame
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0.02, 0)

-- Hàm tạo Text nhanh
local function CreateTxt(name, font, sizeY, color, order)
    local l = Instance.new("TextLabel")
    l.Name = name; l.LayoutOrder = order; l.Size = UDim2.new(1, 0, sizeY, 0)
    l.TextColor3 = color; l.BackgroundTransparency = 1; l.TextScaled = true
    l.FontFace = font; l.Parent = OverlayFrame
    local c = Instance.new("UITextSizeConstraint", l)
    c.MaxTextSize = (name == "Title") and 140 or 50
    return l
end

local TitleLabel = CreateTxt("Title", TextFont, 0.25, Color3.fromRGB(135, 206, 250), 1)
TitleLabel.Text = "Zeraa"
local UserLabel = CreateTxt("User", TextFont, 0.10, Color3.fromRGB(255, 255, 255), 2)
UserLabel.Text = "Username: " .. LocalPlayer.Name
local GameLabel = CreateTxt("Game", TextFont, 0.12, Color3.fromRGB(255, 255, 255), 3)
GameLabel.Text = "Game: Loading..."
local TimeLabel = CreateTxt("Time", TextFont, 0.12, Color3.fromRGB(255, 255, 255), 4)
TimeLabel.Text = "Time: -- | Total: --"
local StatsLabel = CreateTxt("Stats", NumberFont, 0.12, Color3.fromRGB(220, 220, 220), 5)
StatsLabel.Text = "FPS: -- | RAM: -- | ms: --"

-- Lấy tên game
task.spawn(function()
    local s, i = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if s and i then GameLabel.Text = "Game: " .. i.Name else GameLabel.Text = "Game: Unknown" end
end)

-- ====================================================
-- PHẦN 2: MENU TIỆN ÍCH (UTILITY MENU)
-- ====================================================
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "UtilityMenu"
MenuFrame.Size = UDim2.new(0, 300, 0, 350)
MenuFrame.Position = UDim2.new(0.5, -150, 0.5, -175) -- Giữa màn hình
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false -- Ẩn mặc định
MenuFrame.Active = true
MenuFrame.Draggable = true -- Menu cũng kéo được
MenuFrame.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner", MenuFrame); MenuCorner.CornerRadius = UDim.new(0, 10)
local MenuTitle = Instance.new("TextLabel", MenuFrame)
MenuTitle.Size = UDim2.new(1, 0, 0, 40)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "Zeraa Hub Control"
MenuTitle.TextColor3 = Color3.fromRGB(135, 206, 250)
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextSize = 20

local MenuList = Instance.new("UIListLayout", MenuFrame)
MenuList.FillDirection = Enum.FillDirection.Vertical
MenuList.HorizontalAlignment = Enum.HorizontalAlignment.Center
MenuList.Padding = UDim.new(0, 8)
MenuList.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding top cho title
local TitlePad = Instance.new("UIPadding", MenuFrame)
TitlePad.PaddingTop = UDim.new(0, 45)

-- Hàm tạo Nút
local function CreateBtn(text, order, callback)
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = order
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = text
    btn.TextColor3 = Color3.White
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = MenuFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. Rejoin
CreateBtn("Rejoin Server", 1, function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- 2. Server Hop
CreateBtn("Server Hop (Low Player)", 2, function()
    -- Logic Hop đơn giản
    local Http = game:GetService("HttpService")
    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(Servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
            break
        end
    end
end)

-- 3. Copy Job ID
CreateBtn("Copy Job ID", 3, function()
    setclipboard(game.JobId)
    StarterGui:SetCore("SendNotification", {Title="Zeraa Hub", Text="Copied Job ID!"})
end)

-- 4. Send Webhook
CreateBtn("Send Stats to Webhook", 4, function()
    if WebhookURL == "" then 
        StarterGui:SetCore("SendNotification", {Title="Error", Text="No Webhook URL Configured!"})
        return 
    end
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Zeraa Hub Stats",
            ["description"] = "Player: " .. LocalPlayer.Name,
            ["color"] = 8900346,
            ["fields"] = {
                {["name"] = "Game", ["value"] = GameLabel.Text, ["inline"] = true},
                {["name"] = "Time Played", ["value"] = TimeLabel.Text, ["inline"] = false},
                {["name"] = "Job ID", ["value"] = game.JobId, ["inline"] = false}
            }
        }}
    }
    if RequestFunc then
        RequestFunc({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
        StarterGui:SetCore("SendNotification", {Title="Success", Text="Sent to Discord!"})
    end
end)

-- 5. Input Join Job ID
local IDInput = Instance.new("TextBox")
IDInput.LayoutOrder = 5
IDInput.Size = UDim2.new(0.9, 0, 0, 35)
IDInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
IDInput.Text = ""
IDInput.PlaceholderText = "Paste Job ID Here..."
IDInput.TextColor3 = Color3.White
IDInput.Parent = MenuFrame
Instance.new("UICorner", IDInput).CornerRadius = UDim.new(0, 6)

-- 6. Join & Spam Join Logic
local Spamming = false
CreateBtn("Join / Spam Join ID", 6, function()
    local targetID = IDInput.Text
    if targetID == "" then return end
    
    if not Spamming then
        Spamming = true
        StarterGui:SetCore("SendNotification", {Title="Zeraa Hub", Text="Spam Joining ID..."})
        
        task.spawn(function()
            while Spamming do
                -- Thử teleport
                TeleportService:TeleportToPlaceInstance(game.PlaceId, targetID, LocalPlayer)
                -- Chờ một chút trước khi thử lại (nếu thất bại)
                task.wait(1.5) 
            end
        end)
    else
        Spamming = false
        StarterGui:SetCore("SendNotification", {Title="Zeraa Hub", Text="Stopped Spam Join."})
    end
end)


-- ====================================================
-- LOGIC LOOP & KEYBINDS
-- ====================================================
local function FormatTime(s)
    return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor((s%3600)/60), s%60)
end

local FrameCount = 0
local LastTime = os.clock()
RunService.RenderStepped:Connect(function() FrameCount = FrameCount + 1 end)

-- Vòng lặp chính
task.spawn(function()
    while ScreenGui.Parent do
        -- 1. RGB Effect cho Title
        local t = tick()
        local rainbow = Color3.fromHSV((t % 5)/5, 1, 1) -- Đổi màu mỗi 5 giây
        TitleLabel.TextColor3 = rainbow
        
        -- 2. Stats Calculation
        task.wait(1)
        local CurrentTime = os.clock()
        local fps = math.floor(FrameCount / (CurrentTime - LastTime))
        FrameCount = 0; LastTime = CurrentTime
        
        local ram = math.floor(StatsService:GetTotalMemoryUsageMb())
        local ping = 0; pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        
        local CurrentSession = os.time() - SessionStartTime
        local CurrentTotal = SavedTotalTime + CurrentSession
        
        -- 3. Save & Update
        if SessionVal then SessionVal.Value = CurrentSession end
        if TotalVal then TotalVal.Value = CurrentTotal end
        if writefile then writefile(FileName, tostring(CurrentTotal)) end
        
        TimeLabel.Text = string.format("Time: %s  |  Total: %s", FormatTime(CurrentSession), FormatTime(CurrentTotal))
        StatsLabel.Text = string.format("FPS: %d  |  RAM: %d MB  |  ms: %d", fps, ram, ping)
    end
end)

-- Xử lý phím tắt
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == ToggleOverlayKey then
            OverlayFrame.Visible = not OverlayFrame.Visible
            DimFrame.Visible = OverlayFrame.Visible
        elseif input.KeyCode == ToggleMenuKey then
            MenuFrame.Visible = not MenuFrame.Visible
        end
    end
end)

-- Thông báo khởi động
StarterGui:SetCore("SendNotification", {
    Title = "Zeraa/BNN Hub",
    Text = "Banana Cat Hub discord.gg/chuoihub\n[Right Alt] to Open Menu",
    Duration = 99999
})
