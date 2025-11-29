local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function highlightCharacter(character, color)
    if character:FindFirstChild("AdriHighlight") then
        character.AdriHighlight:Destroy()
    end
    local h = Instance.new("Highlight")
    h.Name = "AdriHighlight"
    h.FillColor = color
    h.FillTransparency = 0.5
    h.OutlineColor = Color3.new(1,1,1)
    h.OutlineTransparency = 0
    h.AlwaysOnTop = true
    h.Parent = character
end

local function createBillboard(char, player)
    if char:FindFirstChild("AdriBillboard") then
        char.AdriBillboard:Destroy()
    end
    local head = char:WaitForChild("Head",2)
    if not head then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AdriBillboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,200,0,60)
    billboard.StudsOffset = Vector3.new(0,2.5,0)
    billboard.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.5,0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1,0,0.5,0)
    distanceLabel.Position = UDim2.new(0,0,0.5,0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = ""
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.GothamSemibold
    distanceLabel.TextColor3 = Color3.new(1,1,1)
    distanceLabel.Parent = billboard

    billboard.Parent = char

    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            distanceLabel.Text = string.format("%dm", math.floor(dist+0.5))
        end
    end)
end

local function applyToPlayer(player)
    if player == LocalPlayer then return end
    local function onChar(char)
        task.wait(0.1)
        local color = LocalPlayer:IsFriendsWith(player.UserId) and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,0,0)
        highlightCharacter(char,color)
        createBillboard(char,player)
    end
    player.CharacterAdded:Connect(onChar)
    if player.Character then onChar(player.Character) end
end

for _,plr in ipairs(Players:GetPlayers()) do
    applyToPlayer(plr)
end

Players.PlayerAdded:Connect(applyToPlayer)
