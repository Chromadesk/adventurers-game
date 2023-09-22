--TODO make camera methods!!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponClass = require(ReplicatedStorage.Classes.Items.Weapon)
local ShieldClass = require(ReplicatedStorage.Classes.Items.Shield)
local Class = require(ReplicatedStorage.Classes.Class)
local Player = Class:Extend()

Player.maxHealth = nil
Player.maxSpeed = nil
Player.name = nil
Player.weapon = nil
Player.shield = nil
Player.reference = nil
Player.model = nil
Player.humanoid = nil
Player.attackRemote = nil
Player.guardRemote = nil
Player.animations = nil

function Player:OnNew()
    assert(self.reference, "Player must reference a roblox player")
    assert(self.maxHealth and self.maxHealth >= 1, "Player must have at least 1 health.")
    assert(self.maxSpeed and self.maxSpeed >= 0, "Player must have at least 0 Speed")

    self.name = self.reference.name
    self.model = workspace:WaitForChild(self.name)
    self.humanoid = self.model.Humanoid

    --Server loaded animations
    self.animations = {}
    self.animations["attack"] = self.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Attack)
    self.animations["guard"] = self.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Guard)

    self.humanoid.JumpPower = 0
    self.humanoid.WalkSpeed = self.maxSpeed
    self.humanoid.Health = self.maxHealth
    self.humanoid.MaxHealth = self.maxHealth
    self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)

    self:EquipWeapon(WeaponClass:New({assetFolder = ReplicatedStorage.Assets.Items.Longsword}))
    self:EquipShield(ShieldClass:New({assetFolder = ReplicatedStorage.Assets.Items.Shield}))

    self.attackRemote = Instance.new("RemoteEvent")
    self.attackRemote.Name = "Attack"
    self.attackRemote.Parent = self.model
    self.attackRemote.OnServerEvent:Connect(
        function(player)
            self.weapon:Use(self)
        end
    )
    self.guardRemote = Instance.new("RemoteEvent")
    self.guardRemote.Name = "Guard"
    self.guardRemote.Parent = self.model
    self.guardRemote.OnServerEvent:Connect(
        function(player, isActive)
            self.shield:Use(self, isActive)
        end
    )
end

function Player:TakeDamage(dam)
    self.humanoid.Health = self.humanoid.Health - dam
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
