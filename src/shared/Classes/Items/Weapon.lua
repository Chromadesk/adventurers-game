local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Weapon = Class:Extend()

local HitDetection = require(game:GetService("ReplicatedStorage").Classes.HitDetection)

function Weapon:OnNew()
    assert(self.assetFolder, "Weapons must have an asset folder with their included data.")
    assert(self.assetFolder.Animations, "Weapon asset folder must have an animations folder, even if it is empty.")
    assert(self.attackTime, "Weapon must have an AttackTime stat.")
    assert(self.cooldown, "Weapon must have a Cooldown stat.")
    assert(self.damage, "Weapon must have a Damage stat.")
    assert(self.range, "Weapon must have a Range stat.")

    self.assetFolder = self.assetFolder:Clone()
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

Weapon.onCooldown = false
function Weapon:Use(entity)
    if self.onCooldown then
        return
    end
    self.onCooldown = true
    entity.animations.attack:Play()
    wait(self.attackTime / 2)
    HitDetection:MakeRectangleHitbox(entity, self.range, self.damage)
    wait(self.attackTime / 2 + self.cooldown)
    entity.animations.attack:Stop()
    self.onCooldown = false
end

return Weapon
