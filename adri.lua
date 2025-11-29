local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createBillboard(char, player)
    if char:FindFirstChild("AdriBillboardSafe") then
        char.AdriBillboardSafe:Destroy()
    end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AdriBillboardSafe"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,200,0,60)
    billboard.StudsOffset = Vector3.new(0,2.5,0)
    billboard.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextColor3 = LocalPlayer:IsFriendsWith(player.UserId) and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,0,0)
    nameLabel.Parent = billboard

    billboard.Parent = char
end

local function applyToPlayer(player)
    if player == LocalPlayer then return end
    local function onChar(char)
        task.wait(0.1)
        createBillboard(char,player)
    end
    player.CharacterAdded:Connect(onChar)
    if player.Character then onChar(player.Character) end
end

for _,plr in ipairs(Players:GetPlayers()) do
    applyToPlayer(plr)
end

Players.PlayerAdded:Connect(applyToPlayer)
