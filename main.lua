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
local COLOR_BG = Color3.fromRGB(10, 7, 15)
local COLOR_PANEL = Color3.fromRGB(18, 13, 25)
local COLOR_ACCENT = Color3.fromRGB(139, 92, 246)
local COLOR_ACCENT2 = Color3.fromRGB(167, 139, 250)
local COLOR_TEXT = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_DIM = Color3.fromRGB(148, 163, 184)
local COLOR_SUCCESS = Color3.fromRGB(34, 197, 94)
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
    if success then
        return result
    end
    return false
end
local lastCheck = 0
local checkCooldown = 0.1
task.spawn(function()
    while task.wait(checkCooldown) do
        if autoDefenseEnabled and tick() - lastCheck >= checkCooldown then
            lastCheck = tick()
            local isStealingDetected = checkForStealingNotification()
            if isStealingDetected then
                local now = tick()
                if now - lastDefenseTime >= defenseCooldown then
                    lastDefenseTime = now
                    local myChar = localPlayer.Character
                    if myChar then
                        local myHead = myChar:FindFirstChild("Head")
                        if myHead then
                            local stealer = findClosestPlayerToPosition(myHead.Position)
                            if stealer then
                                print("ðŸ›¡ï¸ Auto Defense: " .. stealer.DisplayName)
                                local channel = TextChatService.TextChannels.RBXGeneral
                                if channel then
                                    local commands = {
                                        ";balloon "  .. stealer.Name,
                                        ";rocket "   .. stealer.Name,
                                        ";morph "    .. stealer.Name,
                                        ";jumpscare ".. stealer.Name,
                                        ";tiny "     .. stealer.Name
                                        ";inverse "     .. stealer.Name
                                        ";nightvision "     .. stealer.Name
                                        ";ragdoll "     .. stealer.Name
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
        ";inverse "     .. targetName
        ";nightvision "     .. targetName
        ";ragdoll "     .. targetName
    }
    local channel = TextChatService.TextChannels.RBXGeneral
    if not channel then
        warn("âŒ RBXGeneral channel not found")
        return
    end
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
    if #selectedPlayers == 0 then
        warn("âŒ No players selected")
        return
    end
    for _, plr in ipairs(selectedPlayers) do
        sendCommands(plr.Name)
    end
    print("âœ… Spammed " .. #selectedPlayers .. " player(s)")
end
local W, H = 160, 220
local gui = Instance.new("ScreenGui")
gui.Name = "VoidHubSpammer"
gui.ResetOnSpawn = false
gui.Parent = localPlayer:WaitForChild("PlayerGui")
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, W, 0, H)
mainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
mainFrame.BackgroundColor3 = COLOR_BG
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame
local borderStroke = Instance.new("UIStroke")
borderStroke.Parent = mainFrame
borderStroke.Thickness = 3
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.LineJoinMode = Enum.LineJoinMode.Round
borderStroke.Transparency = 0
local snakeGradient = Instance.new("UIGradient")
snakeGradient.Parent = borderStroke
snakeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(139, 92, 246)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(88, 28, 135)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246))
}
task.spawn(function()
    local rotation = 0
    while true do
        rotation = (rotation + 3) % 360
        snakeGradient.Rotation = rotation
        task.wait(0.02)
    end
end)
local glowStroke = Instance.new("UIStroke")
glowStroke.Parent = mainFrame
glowStroke.Thickness = 6
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glowStroke.Transparency = 0.7
glowStroke.Color = COLOR_ACCENT
local glowGradient = Instance.new("UIGradient")
glowGradient.Parent = glowStroke
glowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246))
}
task.spawn(function()
    local rotation = 0
    while true do
        rotation = (rotation + 2) % 360
        glowGradient.Rotation = rotation
        task.wait(0.03)
    end
end)
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.ClipsDescendants = true
particleContainer.ZIndex = 1
particleContainer.Parent = mainFrame
task.spawn(function()
    while true do
        for i = 1, 4 do
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
            particle.Position = UDim2.new(math.random(0, 100) / 100, 0, 0, -10)
            local colors = {
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(200, 150, 255),
                Color3.fromRGB(167, 139, 250),
                Color3.fromRGB(139, 92, 246)
            }
            particle.BackgroundColor3 = colors[math.random(1, #colors)]
            particle.BorderSizePixel = 0
            particle.ZIndex = 1
            particle.Parent = particleContainer
            local particleCorner = Instance.new("UICorner")
            particleCorner.CornerRadius = UDim.new(1, 0)
            particleCorner.Parent = particle
            local duration = math.random(10, 18) / 10
            TweenService:Create(particle, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = UDim2.new(particle.Position.X.Scale, 0, 1, 20),
                BackgroundTransparency = 1
            }):Play()
            task.delay(duration, function()
                particle:Destroy()
            end)
        end
        task.wait(0.12)
    end
end)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 28)
header.BackgroundColor3 = COLOR_PANEL
header.BorderSizePixel = 0
header.ZIndex = 2
header.Parent = mainFrame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "VOID SPAMMER"
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.TextColor3 = COLOR_TEXT
title.ZIndex = 2
title.Parent = header
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLOR_ACCENT2),
    ColorSequenceKeypoint.new(0.5, COLOR_ACCENT),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(217, 70, 239))
}
titleGradient.Parent = title
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -26, 0, 2)
closeBtn.BackgroundColor3 = COLOR_ACCENT
closeBtn.Text = "Ã—"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = COLOR_TEXT
closeBtn.ZIndex = 2
closeBtn.Parent = header
local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 5)
closeBtnCorner.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -8, 1, -32)
scrollFrame.Position = UDim2.new(0, 4, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = COLOR_ACCENT
scrollFrame.ZIndex = 2
scrollFrame.Parent = mainFrame
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame
local function createToggle(name, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.95, 0, 0, 24)
    toggleFrame.BackgroundColor3 = COLOR_PANEL
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 2
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 9
    label.TextColor3 = COLOR_TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    label.Parent = toggleFrame
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 34, 0, 16)
    toggle.Position = UDim2.new(1, -38, 0.5, -8)
    toggle.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
    toggle.BorderSizePixel = 0
    toggle.ZIndex = 2
    toggle.Parent = toggleFrame
    local toggleBg = Instance.new("UICorner")
    toggleBg.CornerRadius = UDim.new(0, 8)
    toggleBg.Parent = toggle
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    knob.Parent = toggle
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    local state = false
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state = not state
            TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
                BackgroundColor3 = state and COLOR_ACCENT or Color3.fromRGB(80, 80, 80)
            }):Play()
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = state and COLOR_ACCENT or Color3.fromRGB(25, 20, 35)
            }):Play()
            if callback then
                callback(state)
            end
        end
    end)
    return toggleFrame
end
createToggle("Auto Defense", function(state)
    autoDefenseEnabled = state
end).Parent = scrollFrame
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0.95, 0, 0, 90)
playerListFrame.BackgroundColor3 = COLOR_PANEL
playerListFrame.BorderSizePixel = 0
playerListFrame.ZIndex = 2
playerListFrame.Parent = scrollFrame
local playerListCorner = Instance.new("UICorner")
playerListCorner.CornerRadius = UDim.new(0, 6)
playerListCorner.Parent = playerListFrame
local playerListTitle = Instance.new("TextLabel")
playerListTitle.Size = UDim2.new(1, -6, 0, 14)
playerListTitle.Position = UDim2.new(0, 3, 0, 2)
playerListTitle.BackgroundTransparency = 1
playerListTitle.Text = "Select Targets"
playerListTitle.Font = Enum.Font.GothamBold
playerListTitle.TextSize = 8
playerListTitle.TextColor3 = COLOR_TEXT
playerListTitle.TextXAlignment = Enum.TextXAlignment.Left
playerListTitle.ZIndex = 2
playerListTitle.Parent = playerListFrame
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, -6, 1, -18)
playerScroll.Position = UDim2.new(0, 3, 0, 16)
playerScroll.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 2
playerScroll.ScrollBarImageColor3 = COLOR_ACCENT
playerScroll.ZIndex = 2
playerScroll.Parent = playerListFrame
local playerScrollCorner = Instance.new("UICorner")
playerScrollCorner.CornerRadius = UDim.new(0, 4)
playerScrollCorner.Parent = playerScroll
local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 2)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Parent = playerScroll
local function refreshPlayerList()
    for _, child in ipairs(playerScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            local playerCard = Instance.new("Frame")
            playerCard.Size = UDim2.new(1, -4, 0, 20)
            playerCard.BackgroundColor3 = Color3.fromRGB(20, 15, 28)
            playerCard.BorderSizePixel = 0
            playerCard.ZIndex = 2
            playerCard.Parent = playerScroll
            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 3)
            cardCorner.Parent = playerCard
            local playerName = Instance.new("TextLabel")
            playerName.Size = UDim2.new(1, -24, 1, 0)
            playerName.Position = UDim2.new(0, 4, 0, 0)
            playerName.BackgroundTransparency = 1
            playerName.Text = plr.DisplayName
            playerName.Font = Enum.Font.GothamSemibold
            playerName.TextSize = 8
            playerName.TextColor3 = COLOR_TEXT
            playerName.TextXAlignment = Enum.TextXAlignment.Left
            playerName.ZIndex = 2
            playerName.Parent = playerCard
            local checkmark = Instance.new("TextLabel")
            checkmark.Size = UDim2.new(0, 14, 0, 14)
            checkmark.Position = UDim2.new(1, -17, 0.5, -7)
            checkmark.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
            checkmark.BorderSizePixel = 0
            checkmark.Text = ""
            checkmark.Font = Enum.Font.GothamBold
            checkmark.TextSize = 8
            checkmark.TextColor3 = COLOR_SUCCESS
            checkmark.ZIndex = 2
            checkmark.Parent = playerCard
            local checkCorner = Instance.new("UICorner")
            checkCorner.CornerRadius = UDim.new(0.25, 0)
            checkCorner.Parent = checkmark
            if selectedSet[plr] then
                checkmark.Text = "âœ“"
                checkmark.BackgroundColor3 = COLOR_SUCCESS
            end
            local cardBtn = Instance.new("TextButton")
            cardBtn.Size = UDim2.new(1, 0, 1, 0)
            cardBtn.BackgroundTransparency = 1
            cardBtn.Text = ""
            cardBtn.ZIndex = 3
            cardBtn.Parent = playerCard
            cardBtn.MouseButton1Click:Connect(function()
                if selectedSet[plr] then
                    selectedSet[plr] = nil
                    for i, p in ipairs(selectedPlayers) do
                        if p == plr then table.remove(selectedPlayers, i) break end
                    end
                else
                    selectedSet[plr] = true
                    table.insert(selectedPlayers, plr)
                end
                refreshPlayerList()
            end)
        end
    end
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 4)
end
local spamBtn = Instance.new("TextButton")
spamBtn.Size = UDim2.new(0.95, 0, 0, 26)
spamBtn.BackgroundColor3 = COLOR_ACCENT
spamBtn.Text = "SPAM [F]"
spamBtn.Font = Enum.Font.GothamBold
spamBtn.TextSize = 10
spamBtn.TextColor3 = COLOR_TEXT
spamBtn.ZIndex = 2
spamBtn.Parent = scrollFrame
local spamBtnCorner = Instance.new("UICorner")
spamBtnCorner.CornerRadius = UDim.new(0, 6)
spamBtnCorner.Parent = spamBtn
spamBtn.MouseButton1Click:Connect(function()
    spamSelected()
end)
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.95, 0, 0, 32)
discordBtn.BackgroundColor3 = COLOR_ACCENT
discordBtn.Text = ""
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 8
discordBtn.TextColor3 = COLOR_TEXT
discordBtn.ZIndex = 2
discordBtn.Parent = scrollFrame
local discordBtnCorner = Instance.new("UICorner")
discordBtnCorner.CornerRadius = UDim.new(0, 6)
discordBtnCorner.Parent = discordBtn
local discordTitle = Instance.new("TextLabel")
discordTitle.Size = UDim2.new(1, 0, 0.5, 0)
discordTitle.BackgroundTransparency = 1
discordTitle.Text = "Join Voidhubs Discord For the"
discordTitle.Font = Enum.Font.Gotham
discordTitle.TextSize = 7
discordTitle.TextColor3 = COLOR_TEXT
discordTitle.ZIndex = 3
discordTitle.Parent = discordBtn
local discordSubtitle = Instance.new("TextLabel")
discordSubtitle.Size = UDim2.new(1, 0, 0.5, 0)
discordSubtitle.Position = UDim2.new(0, 0, 0.5, 0)
discordSubtitle.BackgroundTransparency = 1
discordSubtitle.Text = "Best Free And paid Scripts"
discordSubtitle.Font = Enum.Font.GothamBold
discordSubtitle.TextSize = 7
discordSubtitle.TextColor3 = COLOR_TEXT
discordSubtitle.ZIndex = 3
discordSubtitle.Parent = discordBtn
discordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/xzcRvnbncb")
    end)
    local origText1 = discordTitle.Text
    local origText2 = discordSubtitle.Text
    discordTitle.Text = "âœ… Discord Link"
    discordSubtitle.Text = "Copied to Clipboard!"
    task.wait(2)
    discordTitle.Text = origText1
    discordSubtitle.Text = origText2
end)
task.spawn(function()
    while task.wait(0.1) do
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 4)
    end
end)
task.spawn(function()
    task.wait(1)
    refreshPlayerList()
end)
Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    refreshPlayerList()
end)
Players.PlayerRemoving:Connect(function(removedPlayer)
    selectedSet[removedPlayer] = nil
    for i = #selectedPlayers, 1, -1 do
        if selectedPlayers[i] == removedPlayer then
            table.remove(selectedPlayers, i)
        end
    end
    refreshPlayerList()
end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        spamSelected()
    end
end)
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, W, 0, H),
    Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
}):Play()
print("âœ¨ VOID SPAMMER LOADED")
while true do
    task.wait(1)
end
end)
