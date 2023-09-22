local Class = require(game.ReplicatedStorage.Classes.Class)
local Enemy = Class:Extend()
local AiBehaviorClass = require(game.ReplicatedStorage.Classes.Entities.Enemy.AiBehavior)

Enemy.name = nil
Enemy.maxHealth = nil
Enemy.maxSpeed = nil
Enemy.model = nil
Enemy.humanoid = nil
Enemy.AiBehavior = nil

function Enemy:OnNew()
    assert(self.name, "Enemy must have a name.")
    assert(self.assetFolder, "Enemy must have an assetFolder.")
    assert(self.assetFolder[self.name], "Enemy's assetFolder must have a Model.")
    assert(self.assetFolder.Stats, "Enemy's assetFolder must have a Stats folder.")

    self.assetFolder = self.assetFolder:Clone()
    self.model = self.assetFolder[self.name]
    self.maxHealth = self.assetFolder.Stats.Health.Value
    self.maxSpeed = self.assetFolder.Stats.Speed.Value
    self.humanoid = self.model.Humanoid

    self.humanoid.Died:Connect(
        function()
            self:OnDied()
        end
    )
end

function Enemy:TakeDamage(dam)
    self.humanoid.Health = self.humanoid.Health - dam
end

function Enemy:OnDied()
    wait(5)
    self.model:Destroy()
    self.assetFolder:Destroy()
end

function Enemy:Spawn(spawnPos)
    self.model.Parent = workspace.NPCs
    self.model:MoveTo(spawnPos)
    self.AiBehavior = AiBehaviorClass:New({NPC = self})
end

return Enemy
