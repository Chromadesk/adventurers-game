--TODO make camera methods!!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponClass = require(ReplicatedStorage.Classes.Items.Weapon)
local Class = require(ReplicatedStorage.Classes.Class)
local Player = Class:Extend()

Player._maxHealth = nil
Player._maxSpeed = nil
Player._name = nil
Player.health = nil
Player.speed = nil
Player.weapon = nil
Player.shield = nil
Player.reference = nil
Player.model = nil
Player.humanoid = nil
Player.attackRemote = nil
Player.animations = nil

function Player:OnNew()
    assert(self.reference, "Player must reference a roblox player")
    assert(self.health, "Player must have MaxHP")
    assert(self.speed and self.speed >= 0, "Player must have at least 0 Speed")

    self._name = self.reference.name
    self._maxHealth = self.health
    self._maxSpeed = self.speed
    self.model = workspace:WaitForChild(self._name)
    self.humanoid = self.model.Humanoid
    self.animations = {}
    self.animations["attack"] = self.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Attack)
    self.animations["guard"] = self.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Guard)

    self.humanoid.JumpPower = 0
    self.humanoid.WalkSpeed = self._maxSpeed
    self.humanoid.Health = self._maxHealth
    self.humanoid.MaxHealth = self._maxHealth
    self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    self:EquipWeapon(WeaponClass:New({assetFolder = ReplicatedStorage.Assets.Items.Longsword}))

    self.attackRemote = Instance.new("RemoteEvent")
    self.attackRemote.Name = "Attack"
    self.attackRemote.Parent = self.model
    self.attackRemote.OnServerEvent:Connect(
        function(player)
            self.weapon:Use(self)
        end
    )
end

function Player:TakeDamage(dam)
    self.health = self.health - dam
    if self.health <= 0 then
        self:OnDeath()
        return
    end
end

function Player:OnDeath()
    --placeholder
end

function Player:EquipWeapon(weapon)
    self.weapon = weapon

    weapon:Equip(self)
end

function Player:EquipShield(shield)
    self.shield = shield

    shield:Equip(self)
end

return Player
