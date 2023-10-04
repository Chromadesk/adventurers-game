--TODO make camera methods!!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Entity = require(game.ReplicatedStorage.Classes.Entities.Entity)
local GamePlayer = Entity:Extend()

local HitDetection = require(game:GetService("ReplicatedStorage").Classes.HitDetection)

function GamePlayer:OnNew()
    assert(self.reference, "GamePlayer must reference a roblox player")

    self.name = self.reference.name
    self.model = workspace:WaitForChild(self.name)
    self.model.Parent = workspace.PlayerCharacters
    self.humanoid = self.model.Humanoid
    self.attackRemote = nil
    self.guardRemote = nil

    --Server loaded animations
    self.animations = {}
    self.animations["attack"] = self.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Attack)
    self.animations["guard"] = self.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Guard)

    HitDetection:InitializeCollisionBox(self.model)

    self:InitializeRemotes()
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

return GamePlayer
