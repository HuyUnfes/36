local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")

-- Hàm ẩn 50% phần giữa của tên
local function hideNameMiddle(name)
    local len = #name
    if len <= 2 then return name end
    local quarter = math.floor(len * 0.25)
    local visibleStart = math.max(1, quarter)
    local visibleEnd = math.max(1, quarter)
    local startPart = string.sub(name, 1, visibleStart)
    local endPart = string.sub(name, len - visibleEnd + 1, len)
    local hiddenPart = string.rep("*", len - visibleStart - visibleEnd)
    return startPart .. hiddenPart .. endPart
end

-- Tạo GUI chính
local nameHub = Instance.new("ScreenGui")
nameHub.Name = "NameHub"
nameHub.Parent = playerGui
nameHub.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = nameHub
mainFrame.Size = UDim2.new(0.5, 0, 0, 0) -- Chiều cao tự động
mainFrame.Position = UDim2.new(0.5, 0, 0.15, 0) 
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.Active = true 
mainFrame.Draggable = true 
mainFrame.AutomaticSize = Enum.AutomaticSize.Y -- Tự động giãn chiều cao

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.1, 0)
uiCorner.Parent = mainFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.Parent = mainFrame
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.PaddingBottom = UDim.new(0, 5) -- Giảm padding dưới để Stats sát đáy
uiPadding.PaddingLeft = UDim.new(0, 10)
uiPadding.PaddingRight = UDim.new(0, 10)

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = mainFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 5)

-- 1. Hiển thị tên
local nameLabel = Instance.new("TextLabel")
nameLabel.Name = "NameLabel"
nameLabel.Parent = mainFrame
nameLabel.Size = UDim2.new(1, 0, 0, 30)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextScaled = true
nameLabel.Font = Enum.Font.GothamBold
nameLabel.Text = "👤 Tên: " .. hideNameMiddle(player.Name)
nameLabel.LayoutOrder = 1

-- 2. Khung chứa phần Đơn
local jobFrame = Instance.new("Frame")
jobFrame.Name = "JobFrame"
jobFrame.Parent = mainFrame
jobFrame.Size = UDim2.new(1, 0, 0, 0)
jobFrame.AutomaticSize = Enum.AutomaticSize.Y
jobFrame.BackgroundTransparency = 1
jobFrame.LayoutOrder = 2

local listLayoutJob = Instance.new("UIListLayout")
listLayoutJob.Parent = jobFrame
listLayoutJob.FillDirection = Enum.FillDirection.Horizontal
listLayoutJob.SortOrder = Enum.SortOrder.LayoutOrder
listLayoutJob.VerticalAlignment = Enum.VerticalAlignment.Top

local jobTitle = Instance.new("TextLabel")
jobTitle.Parent = jobFrame
jobTitle.Size = UDim2.new(0.15, 0, 0, 30)
jobTitle.BackgroundTransparency = 1
jobTitle.TextColor3 = Color3.fromRGB(255, 223, 88)
jobTitle.TextScaled = true
jobTitle.Font = Enum.Font.GothamBold
jobTitle.Text = "📌 Đơn:"
jobTitle.LayoutOrder = 1

-- Ô nhập liệu (TextBox)
local jobBox = Instance.new("TextBox")
jobBox.Parent = jobFrame
jobBox.Size = UDim2.new(0.85, 0, 0, 30)
jobBox.BackgroundTransparency = 1 -- Để trong suốt để thấy viền
jobBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jobBox.TextSize = 20
jobBox.Font = Enum.Font.GothamBold
jobBox.PlaceholderText = "Nhập nội dung..."
jobBox.Text = ""
jobBox.ClearTextOnFocus = false
jobBox.TextWrapped = true
jobBox.MultiLine = true
jobBox.AutomaticSize = Enum.AutomaticSize.Y
jobBox.TextXAlignment = Enum.TextXAlignment.Left
jobBox.TextYAlignment = Enum.TextYAlignment.Top
jobBox.LayoutOrder = 2

-- === THÊM VIỀN CẦU VỒNG CHO TEXTBOX ===
local boxStroke = Instance.new("UIStroke")
boxStroke.Parent = jobBox
boxStroke.Thickness = 2
boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
-- Script đổi màu cầu vồng
task.spawn(function()
    while true do
        for i = 0, 1, 0.005 do
            boxStroke.Color = Color3.fromHSV(i, 1, 1) -- Đổi màu theo vòng
            task.wait(0.02)
        end
    end
end)

-- 3. Phần hiển thị Stats (Góc dưới phải)
local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "StatsLabel"
statsLabel.Parent = mainFrame
statsLabel.Size = UDim2.new(1, 0, 0, 20) -- Cao 20px
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = Color3.fromRGB(135, 206, 250) -- Màu xanh nhạt (Light Sky Blue)
statsLabel.TextSize = 14
statsLabel.Font = Enum.Font.SourceSans -- Font cơ bản, không cần đẹp
statsLabel.TextXAlignment = Enum.TextXAlignment.Right -- Căn lề phải
statsLabel.LayoutOrder = 3 -- Nằm dưới cùng
statsLabel.Text = "FPS: .. RAM: ..% ms: ..%"

-- Script cập nhật Stats
task.spawn(function()
    while true do
        local fps = math.floor(workspace:GetRealPhysicsFPS())
        local memory = math.floor(StatsService:GetTotalMemoryUsageMb())
        -- Lấy Ping (cần check nil để tránh lỗi)
        local ping = 0
        pcall(function()
            ping = math.floor(player:GetNetworkPing() * 1000) -- Đổi từ giây sang ms
        end)
        
        -- Cập nhật text theo format yêu cầu
        statsLabel.Text = string.format("FPS: %d RAM: %d%% ms: %d%%", fps, memory, ping)
        task.wait(1) -- Cập nhật mỗi 1 giây để đỡ lag
    end
end)

-- Xử lý lưu file
jobBox.FocusLost:Connect(function(enterPressed)
    local content = jobBox.Text
    if content ~= "" then
        local folderName = "Zeraa"
        local fileName = "Txt_" .. player.Name .. ".txt"
        local filePath = folderName .. "/" .. fileName
        
        if makefolder and writefile and isfolder then
            if not isfolder(folderName) then
                makefolder(folderName)
            end
            writefile(filePath, content)
            print("Đã lưu đơn vào: " .. filePath)
            
            -- Hiệu ứng nháy chữ xanh lá khi lưu
            local originalColor = jobBox.TextColor3
            jobBox.TextColor3 = Color3.fromRGB(85, 255, 127)
            task.wait(0.5)
            jobBox.TextColor3 = originalColor
        end
    end
end)
