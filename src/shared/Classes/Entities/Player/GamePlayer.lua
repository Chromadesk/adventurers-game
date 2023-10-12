--TODO make camera methods!!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Entity = require(game.ReplicatedStorage.Classes.Entities.Entity)
local GamePlayer = Entity:Extend()
local ItemEnum = require(game.ReplicatedStorage.Classes.Items.ItemEnum)
local WeaponClass = require(ReplicatedStorage.Classes.Items.Weapon)
local ShieldClass = require(ReplicatedStorage.Classes.Items.Shield)

local HitDetection = require(game:GetService("ReplicatedStorage").Classes.HitDetection)

function GamePlayer:Initialize()
    self:EquipWeapon(WeaponClass:New(ItemEnum.Weapons.LONGSWORD))
    self:EquipShield(ShieldClass:New(ItemEnum.Shields.SHIELD))
    ReplicatedStorage.Remotes.LoadAnimations:FireClient(self.assetFolder, self)
    self:InitializeRemotes()
    self:LoadAnimations()
    self.model.Parent = workspace.PlayerCharacters
end

function GamePlayer:HandleHit(contact)
    --placeholder
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

function GamePlayer:LoadAnimations()
    self.animations["attack"] = self.animator:LoadAnimation(ReplicatedStorage.Assets.Animations.Attack)
    self.animations["guard"] = self.animator:LoadAnimation(ReplicatedStorage.Assets.Animations.Guard)
end

return GamePlayer
