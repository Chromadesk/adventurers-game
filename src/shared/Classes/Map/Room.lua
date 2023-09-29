local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Room = Class:Extend()

local EnemyClass = require(game.ReplicatedStorage.Classes.Entities.Enemy.Enemy)

function Room:OnNew()
    assert(self.model, "Room requires a room model")
    assert(self.model:FindFirstChild("EnterDoor", true), "Room requires an EnterDoor")
    assert(self.model:FindFirstChild("ExitDoor", true), "Room requires an ExitDoor")
    assert(self.index, "Room must have an index.")

    self.model = self.model:Clone()
    self.name = self.model.Name
    self.enterDoor = self.model:FindFirstChild("EnterDoor", true)
    self.exitDoor = self.model:FindFirstChild("ExitDoor", true)
    self.enemies = {}

    self.model.Roof.Transparency = 0.3

    if self.isSpawnRoom then
        self:InitializePlayerSpawns()
    end
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
    self.model.Roof.Transparency = 1
end

function Room:SpawnEnemies()
    if not self.model:FindFirstChild("EnemySpawns") then
        return
    end

    local i = 1
    for _, v in pairs(self.model.EnemySpawns:GetChildren()) do
        v.Transparency = 1
        v.CanCollide = false
        if #self.enemies < 1 or math.random(1, 100) <= 60 then
            self.enemies[i] =
                EnemyClass:New({name = "Bandit", assetFolder = game.ReplicatedStorage.Assets.Enemies["Bandit"]})

            self.enemies[i].humanoid.Died:Connect(
                function()
                    print(i)
                    self.enemies[i] = nil
                    print(self.enemies)
                end
            )

            self.enemies[i]:Spawn(v.Position)
        end
        i = i + 1
    end
end

function Room:Unlock()
    self.model.Roof.Transparency = 1
    for _, v in pairs(self.enemies) do
        task.spawn(
            function()
                v.AiBehavior:FollowPlayer()
            end
        )
    end
end

return Room
