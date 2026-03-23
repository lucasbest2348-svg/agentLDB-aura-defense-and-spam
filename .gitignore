task.spawn(function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TextChatService = game:GetService("TextChatService")
local localPlayer = Players.LocalPlayer
if not localPlayer.Character then
    localPlayer.CharacterAdded:Wait()
end
task.wait(0.5)

-- UPDATED COLORS (BLACK / WHITE / BLUE)
local COLOR_BG = Color3.fromRGB(5, 5, 10)
local COLOR_PANEL = Color3.fromRGB(15, 15, 25)
local COLOR_ACCENT = Color3.fromRGB(0, 170, 255)
local COLOR_ACCENT2 = Color3.fromRGB(120, 200, 255)
local COLOR_TEXT = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_DIM = Color3.fromRGB(180, 180, 180)
local COLOR_SUCCESS = Color3.fromRGB(0, 170, 255)

local autoDefenseEnabled = false
local lastDefenseTime = 0
local defenseCooldown = 3

local function getPlayerHead(plr)
    local char = plr.Character
    if not char then return nil end
    return char:FindFirstChild("Head")
end

local function findClosestPlayerToPosition(position)
    local closestPlayer
    local closestDist = math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            local head = getPlayerHead(plr)
            if head then
                local dist = (head.Position - position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestPlayer = plr
                end
            end
        end
    end
    return closestPlayer
end

local function checkForStealingNotification()
    local success, result = pcall(function()
        local notificationGui = localPlayer.PlayerGui:FindFirstChild("Notification")
        if not notificationGui then return false end
        local notificationFrame = notificationGui:FindFirstChild("Notification")
        if not notificationFrame then return false end
        local children = notificationFrame:GetChildren()
        if #children < 4 then return false end
        local textLabel = children[4]
        if not textLabel:IsA("TextLabel") then return false end
        local fullText = textLabel.Text
        if fullText:find("Someone is stealing your") then
            return true
        end
        return false
    end)
    if success then return result end
    return false
end

local lastCheck = 0
local checkCooldown = 0.1

task.spawn(function()
    while task.wait(checkCooldown) do
        if autoDefenseEnabled and tick() - lastCheck >= checkCooldown then
            lastCheck = tick()
            if checkForStealingNotification() then
                local now = tick()
                if now - lastDefenseTime >= defenseCooldown then
                    lastDefenseTime = now
                    local myChar = localPlayer.Character
                    if myChar then
                        local myHead = myChar:FindFirstChild("Head")
                        if myHead then
                            local stealer = findClosestPlayerToPosition(myHead.Position)
                            if stealer then
                                print("Auto Defense: " .. stealer.DisplayName)
                                local channel = TextChatService.TextChannels.RBXGeneral
                                if channel then
                                    local commands = {
                                        ";balloon "  .. stealer.Name,
                                        ";rocket "   .. stealer.Name,
                                        ";morph "    .. stealer.Name,
                                        ";jumpscare ".. stealer.Name,
                                        ";tiny "     .. stealer.Name
                                        ";inverse "  .. stealer.Name,
                                        ";nightvision " .. stealer.Name,
                                        ";ragdoll "  .. stealer.Name
                                    }
                                    task.spawn(function()
                                        for _, cmd in ipairs(commands) do
                                            pcall(function()
                                                channel:SendAsync(cmd)
                                            end)
                                            task.wait(0.1)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

local selectedPlayers = {}
local selectedSet = {}

local function sendCommands(targetName)
    local commands = {
        ";balloon "  .. targetName,
        ";rocket "   .. targetName,
        ";morph "    .. targetName,
        ";jumpscare ".. targetName,
        ";tiny "     .. targetName
        ";inverse "  .. targetName,
        ";nightvision " .. targetName,
        ";ragdoll "  .. targetName
    }

    local channel = TextChatService.TextChannels.RBXGeneral
    if not channel then return end

    task.spawn(function()
        for _, cmd in ipairs(commands) do
            pcall(function()
                channel:SendAsync(cmd)
            end)
            task.wait(0.1)
        end
    end)
end

local function spamSelected()
    if #selectedPlayers == 0 then return end
    for _, plr in ipairs(selectedPlayers) do
        sendCommands(plr.Name)
    end
end

-- GUI
local W, H = 160, 220
local gui = Instance.new("ScreenGui")
gui.Name = "agentLDBAuraDefense"
gui.ResetOnSpawn = false
gui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, W, 0, H)
mainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
mainFrame.BackgroundColor3 = COLOR_BG
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

local borderStroke = Instance.new("UIStroke", mainFrame)
borderStroke.Thickness = 3

local snakeGradient = Instance.new("UIGradient", borderStroke)
snakeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLOR_ACCENT),
    ColorSequenceKeypoint.new(0.5, COLOR_ACCENT2),
    ColorSequenceKeypoint.new(1, COLOR_ACCENT)
}

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 28)
header.BackgroundColor3 = COLOR_PANEL

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "agentLDB aura defense"
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.TextColor3 = COLOR_TEXT

local titleGradient = Instance.new("UIGradient", title)
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLOR_ACCENT2),
    ColorSequenceKeypoint.new(0.5, COLOR_ACCENT),
    ColorSequenceKeypoint.new(1, COLOR_TEXT)
}

print("agentLDB aura defense loaded")

while true do
    task.wait(1)
end
end)
