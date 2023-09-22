local Class = require(game.ReplicatedStorage.Classes.Class)
local Enemy = Class:Extend()

Enemy.name = nil
Enemy.maxHealth = nil
Enemy.maxSpeed = nil
Enemy.model = nil
Enemy.humanoid = nil

function Enemy:OnNew()
    assert(self.name, "Enemy must have a name.")
    assert(self.assetFolder, "Enemy must have an assetFolder.")
    assert(self.assetFolder[self.name], "Enemy's assetFolder must have a Model.")
    assert(self.assetFolder.Stats, "Enemy's assetFolder must have a Stats folder.")

    self.assetFolder = self.assetFolder:Clone()
    self.model = self.assetFolder[self.name]
    self.maxHealth = self.assetFolder.Stats.Health
    self.maxSpeed = self.assetFolder.Stats.Speed
    self.humanoid = self.model.Humanoid
end

function Enemy:TakeDamage(dam)
    self.humanoid.Health = self.humanoid.Health - dam
end

function Enemy:OnDeath()
end

return Enemy
