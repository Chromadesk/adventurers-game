local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Weapon = Class:Extend()

local HitDetection = require(game:GetService("ReplicatedStorage").Classes.HitDetection)

Weapon.assetFolder = nil
Weapon.statsFolder = nil
Weapon.attackTime = nil
Weapon.cooldown = nil
Weapon.damage = nil
Weapon.range = nil
Weapon.model = nil

function Weapon:OnNew()
    assert(self.assetFolder, "Weapons must have an asset folder with their included data.")
    assert(self.assetFolder.Animations, "Weapon asset folder must have an animations folder, even if it is empty.")
    assert(self.assetFolder.Stats, "Weapon asset folder must have a stats folder even if it is empty.")
    assert(self.assetFolder.Stats.AttackTime, "Weapon must have an AttackTime stat.")
    assert(self.assetFolder.Stats.Cooldown, "Weapon must have a Cooldown stat.")
    assert(self.assetFolder.Stats.Damage, "Weapon must have a Damage stat.")
    assert(self.assetFolder.Stats.Range, "Weapon must have a Range stat.")

    self.assetFolder = self.assetFolder:Clone()
    self.statsFolder = self.assetFolder.Stats
    self.attackTime = self.statsFolder.AttackTime.Value
    self.cooldown = self.statsFolder.Cooldown.Value
    self.damage = self.statsFolder.Damage.Value
    self.range = self.statsFolder.Range.Value
    self.model = self.assetFolder.Model

    self:IntializeModel()
end

function Weapon:Equip(entity)
    self.assetFolder.Parent = entity.model
end

function Weapon:IntializeModel()
    self.model.CanCollide = false
    self.model.Anchored = false

    local handle = self.assetFolder.Handle
    handle.CanCollide = false
    handle.Anchored = false
    handle.Transparency = 1
end

local onCooldown = false
function Weapon:Use(entity)
    if onCooldown then
        return
    end
    onCooldown = true
    entity.animations.attack:Play()
    wait(self.attackTime / 2)
    HitDetection:MakeRectangleHitbox(entity.model, self.range, self.damage)
    wait(self.attackTime / 2 + self.cooldown)
    entity.animations.attack:Stop()
    onCooldown = false
end

return Weapon
