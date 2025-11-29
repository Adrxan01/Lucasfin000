local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local ESP_ENABLED = true
local SHOW_NAME = true
local SHOW_DISTANCE = true

local function highlightCharacter(character, color)
    local old = character:FindFirstChild("RelationHighlight")
    if old then old:Destroy() end

    local h = Instance.new("Highlight")
    h.Name = "RelationHighlight"
    h.FillColor = color
    h.FillTransparency = 0.5
    h.OutlineColor = Color3.new(1,1,1)
    h.OutlineTransparency = 0
    h.AlwaysOnTop = true
    h.Parent = character
end

local function makeBillboard(char, player)
    local old = char:FindFirstChild("NameBillboard")
    if old then old:Destroy() end

    local head = char:WaitForChild("Head", 2)
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameBillboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true

    local nameL = Instance.new("TextLabel")
    nameL.BackgroundTransparency = 1
    nameL.Size = UDim2.new(1,0,0.5,0)
    nameL.TextScaled = true
    nameL.Font = Enum.Font.GothamBold
    nameL.TextColor3 = Color3.new(1,1,1)
    nameL.Text = player.Name
    nameL.Name = "NameLabel"
    nameL.Parent = billboard

    local distL = Instance.new("TextLabel")
    distL.BackgroundTransparency = 1
    distL.Size = UDim2.new(1,0,0.5,0)
    distL.Position = UDim2.new(0,0,0.5,0)
    distL.TextScaled = true
    distL.Font = Enum.Font.GothamSemibold
    distL.TextColor3 = Color3.new(1,1,1)
    distL.Text = ""
    distL.Name = "DistanceLabel"
    distL.Parent = billboard

    billboard.Parent = char

    RunService.RenderStepped:Connect(function()
        if not billboard.Parent then return end
        
        billboard.Enabled = ESP_ENABLED
        nameL.Visible = SHOW_NAME
        distL.Visible = SHOW_DISTANCE

        if ESP_ENABLED and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if char:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position -
                    LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                distL.Text = string.format("%dm", dist//1)
            end
        end
    end)
end

local function apply(player)
    if player == LocalPlayer then return end
    
    local function onChar(char)
        task.wait(0.1)
        
        local color = LocalPlayer:IsFriendsWith(player.UserId)
            and Color3.fromRGB(255,255,0)
            or Color3.fromRGB(255,0,0)

        highlightCharacter(char, color)
        makeBillboard(char, player)
    end

    player.CharacterAdded:Connect(onChar)
    if player.Character then onChar(player.Character) end
end

for _,p in ipairs(Players:GetPlayers()) do
    apply(p)
end
Players.PlayerAdded:Connect(apply)

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 180, 0, 150)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0,6)

local function makeToggle(name, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0,5,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.MouseButton1Click:Connect(callback)
end

makeToggle("ESP", function() ESP_ENABLED = not ESP_ENABLED end)
makeToggle("Namen", function() SHOW_NAME = not SHOW_NAME end)
makeToggle("Distanz", function() SHOW_DISTANCE = not SHOW_DISTANCE end)
