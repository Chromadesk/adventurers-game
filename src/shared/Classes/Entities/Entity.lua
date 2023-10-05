local Class = require(game.ReplicatedStorage.Classes.Class)
local Entity = Class:Extend()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitDetection = require(ReplicatedStorage.Classes.HitDetection)

function Entity:OnNew()
    assert(self.name, "Entities must have a name.")
    assert(self.assetFolder, "Entities must have an assetFolder.")
    assert(self.model or self.assetFolder[self.name], "Entities must have a Model (can be put in assetFolder)")
    assert(self.maxHealth and self.maxHealth >= 1, "Entities must have at least 1 health. (missing maxHealth)")
    assert(self.maxSpeed and self.maxSpeed >= 0, "Entities must have at least 0 Speed (missing maxSpeed)")
    assert(self.weapon, "Entities must have a default weapon.")

    if not self.assetFolder:IsA("Player") then
        self.assetFolder = self.assetFolder:Clone()
    end
    if not self.model then
        print("frog")
        self.model = self.assetFolder[self.name]
    end
    self.humanoid = self.model.Humanoid
    self.animator = self.humanoid.Animator
    self.animations = {}

    self.humanoid.Died:Connect(
        function()
            self:OnDied()
        end
    )

    self:InitializeHumanoid()
    HitDetection:InitializeCollisionBox(self.model)
end

function Entity:TakeDamage(damage, attacker)
    self.humanoid.Health = self.humanoid.Health - damage
end

function Entity:OnDied()
    wait(5)
    self.model:Destroy()
    self:GetWorld():RemoveObject(self)
end

function Entity:EquipWeapon(weapon)
    self.weapon = weapon
    weapon:Equip(self)
end

function Entity:EquipShield(shield)
    self.shield = shield
    shield:Equip(self)
end

function Entity:InitializeHumanoid()
    self.humanoid.JumpPower = 0
    self.humanoid.WalkSpeed = self.maxSpeed
    self.humanoid.Health = self.maxHealth
    self.humanoid.MaxHealth = self.maxHealth
    self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    self.humanoid.AutoRotate = false
    self.humanoid.MaxSlopeAngle = 0
end

function Entity:LoadAnimations()
    throw("Entities must have a LoadAnimations() method.")
end

function Entity:HandleHit()
    throw("Entities must have a HandleHit() method.")
end

function Entity:Initialize()
    throw("Entities must have a Initialize() method.")
end

return Entity
