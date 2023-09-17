local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Entity = Class:Extend()

Entity._maxHealth = nil
Entity._maxArmor = nil
Entity._maxSpeed = nil
Entity._name = nil
Entity.health = nil
Entity.armor = nil
Entity.speed = nil
Entity.weapon = nil --weapon object
Entity.shield = nil --shield object
Entity.skills = nil --table of skills

function Entity:OnNew()
    assert(self.name, "Entity must be named")
    assert(self.health, "Entity must have MaxHP")
    assert(self.armor and self.armor >= 0, "Entity must have at least 0 Armor")
    assert(self.speed and self.speed >= 0, "Entity must have at least 0 Speed")

    self._name = self.name
    self._maxHealth = self.health
    self._maxArmor = self.armor
    self._maxSpeed = self.speed

    self:_Initalize()
end

--TODO: Armor absorbs damage until broken
function Entity:TakeDamage(dam)
    self.health = self.health - dam
    if self.health <= 0 then
        self:OnDeath()
        return
    end
end

function Entity:OnDeath()
    --placeholder
end

---------------------
--[INITIALIZATIONS]--
---------------------

function Entity:_Initialize()
end

return Entity
