local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Room = Class:Extend()

local EnemyClass = require(game.ReplicatedStorage.Classes.Entities.Enemy.Enemy)

Room.name = nil
Room.model = nil
Room.enterDoor = nil
Room.exitDoor = nil
Room.isSpawnRoom = false
Room.enemies = {}

function Room:OnNew()
    assert(self.model, "Room requires a room model")
    assert(self.model:FindFirstChild("EnterDoor", true), "Room requires an EnterDoor")
    assert(self.model:FindFirstChild("ExitDoor", true), "Room requires an ExitDoor")

    self.model = self.model:Clone()
    self.name = self.model.Name
    self.enterDoor = self.model:FindFirstChild("EnterDoor", true)
    self.exitDoor = self.model:FindFirstChild("ExitDoor", true)

    if self.isSpawnRoom then
        self:InitializePlayerSpawns()
    end

    self:InitializeDoors()
end

--TODO: Fix this, spawns should disable when they are inside other blocks
function Room:InitializePlayerSpawns()
    local spawnFloor = game:GetService("ReplicatedStorage").Assets.Rooms.SpawnFloor:Clone()
    spawnFloor.Parent = self.model
    spawnFloor:SetPrimaryPartCFrame(self.model:GetPrimaryPartCFrame())
    for _, i in pairs(spawnFloor:GetChildren()) do
        i.Transparency = 1
        if i.Name == "SpawnLocation" and #workspace:GetPartsInPart(i) > 0 then
            i.Enabled = false
        end
    end
end

function Room:InitializeDoors()
    self.enterDoor.CanCollide = false
    self.enterDoor.Transparency = 1

    -- function weld(part)
    -- local weld = Instance.new("WeldConstraint")
    -- weld.Part0 = part
    -- weld.Part1 =
    -- end
end

function Room:SpawnEnemies()
    local i = 1
    if not self.model:FindFirstChild("EnemySpawns") then
        return
    end

    for _, v in pairs(self.model.EnemySpawns:GetChildren()) do
        if #self.enemies < 1 or math.random(1, 100) <= 60 then
            v.Transparency = 1
            v.CanCollide = false

            self.enemies[i] =
                EnemyClass:New({name = "Bandit", assetFolder = game.ReplicatedStorage.Assets.Enemies["Bandit"]})
            print(self.enemies)

            self.enemies[i].model.Destroying:Connect(
                function()
                    wait(1)
                    self.enemies[i] = nil
                end
            )

            self.enemies[i]:Spawn(v.Position)
            print("spawned enemy")
        end
        i = i + 1
    end
end

return Room
