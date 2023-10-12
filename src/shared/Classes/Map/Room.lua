local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Room = Class:Extend()

local Utility = require(game:GetService("ReplicatedStorage").Classes.Utility)
local Enemy = require(game.ReplicatedStorage.Classes.Entities.Enemy.Enemy)
local SpawnEnum = require(game.ReplicatedStorage.Classes.Entities.Enemy.SpawnEnum)

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
        self:SpawnEnemies()
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
        if math.random(1, 100) <= 60 and not self.isSpawnRoom then
            local newem = Enemy:New(Utility:Copy(SpawnEnum.Enemies.BANDIT))
            self.enemies[i] = newem

            newem.humanoid.Died:Connect(
                function()
                    local trueIndex = table.find(self.enemies, newem)
                    table.remove(self.enemies, trueIndex)
                end
            )

            newem:Initialize(v.Position)
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
