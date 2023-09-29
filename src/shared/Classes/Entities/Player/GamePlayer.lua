--TODO make camera methods!!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Classes.Class)
local GamePlayer = Class:Extend()

local WeaponClass = require(ReplicatedStorage.Classes.Items.Weapon)
local ShieldClass = require(ReplicatedStorage.Classes.Items.Shield)
local HitDetection = require(game:GetService("ReplicatedStorage").Classes.HitDetection)

GamePlayer.maxHealth = nil
GamePlayer.maxSpeed = nil
GamePlayer.name = nil
GamePlayer.weapon = nil
GamePlayer.shield = nil
GamePlayer.reference = nil
GamePlayer.model = nil
GamePlayer.humanoid = nil
GamePlayer.attackRemote = nil
GamePlayer.guardRemote = nil
GamePlayer.animations = nil

function GamePlayer:OnNew()
    assert(self.reference, "GamePlayer must reference a roblox player")
    assert(self.maxHealth and self.maxHealth >= 1, "GamePlayer must have at least 1 health.")
    assert(self.maxSpeed and self.maxSpeed >= 0, "GamePlayer must have at least 0 Speed")

    self.name = self.reference.name
    self.model = workspace:WaitForChild(self.name)
    self.model.Parent = workspace.PlayerCharacters
    self.humanoid = self.model.Humanoid

    --Server loaded animations
    self.animations = {}
    self.animations["attack"] = self.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Attack)
    self.animations["guard"] = self.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Guard)

    self:InitializeHumanoid()
    HitDetection:InitializeCollisionBox(self.model)

    self:EquipWeapon(WeaponClass:New({assetFolder = ReplicatedStorage.Assets.Items.Longsword}))
    self:EquipShield(ShieldClass:New({assetFolder = ReplicatedStorage.Assets.Items.Shield}))

    self:InitializeRemotes()
end

function GamePlayer:TakeDamage(dam)
    self.humanoid.Health = self.humanoid.Health - dam
end

function GamePlayer:OnDeath()
    --placeholder
end

function GamePlayer:EquipWeapon(weapon)
    self.weapon = weapon

    weapon:Equip(self)
end

function GamePlayer:EquipShield(shield)
    self.shield = shield

    shield:Equip(self)
end

function GamePlayer:HandleHit(contact)
    --placeholder
end

function GamePlayer:InitializeHumanoid()
    self.humanoid.JumpPower = 0
    self.humanoid.WalkSpeed = self.maxSpeed
    self.humanoid.Health = self.maxHealth
    self.humanoid.MaxHealth = self.maxHealth
    self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    self.humanoid.AutoRotate = false
    self.humanoid.MaxSlopeAngle = 0
end

function GamePlayer:InitializeRemotes()
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

return GamePlayer
