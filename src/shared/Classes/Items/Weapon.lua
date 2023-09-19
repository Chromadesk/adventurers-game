local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Weapon = Class:Extend()

Weapon.assetFolder = nil
Weapon.statsFolder = nil
Weapon.attackTime = nil
Weapon.attackCooldown = nil
Weapon.attackDamage = nil
Weapon.model = nil

function Weapon:OnNew()
    assert(self.assetFolder, "Weapons must have an asset folder with their included data.")
    assert(self.assetFolder.Animations, "Weapon asset folder must have an animations folder, even if it is empty.")
    assert(self.assetFolder.Stats, "Weapon asset folder must have a stats folder even if it is empty.")

    self.assetFolder = self.assetFolder:Clone()
    self.statsFolder = self.assetFolder.Stats
    self.attackTime = self.statsFolder.AttackTime.Value
    self.attackCooldown = self.statsFolder.Cooldown.Value
    self.attackDamage = self.statsFolder.Damage.Value
    self.model = self.assetFolder.Model

    self:IntializeModel()
    self:InitializeAnimations()
end

function Weapon:Equip(player)
    self.assetFolder.Parent = player.model
end

function Weapon:IntializeModel()
    self.model.CanCollide = false
    self.model.Anchored = false

    local handle = self.assetFolder.Handle
    handle.CanCollide = false
    handle.Anchored = false
    handle.Transparency = 1
end

function Weapon:InitializeAnimations()
    --placeholder
end

return Weapon
