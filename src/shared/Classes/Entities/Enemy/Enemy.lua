local Entity = require(game.ReplicatedStorage.Classes.Entities.Entity)
local Enemy = Entity:Extend()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AiBehaviorClass = require(ReplicatedStorage.Classes.Entities.Enemy.AiBehavior)
local WeaponClass = require(ReplicatedStorage.Classes.Items.Weapon)

function Enemy:Initialize(spawnPos)
    self:EquipWeapon(WeaponClass:New(self.weapon))
    self:AddTeamTag("enemy")
    self.model.Parent = workspace.NPCs
    self:LoadAnimations()
    self.model:MoveTo(spawnPos)
    task.spawn(
        function()
            self.AiBehavior = AiBehaviorClass:New({NPC = self})
        end
    )
end

function Enemy:HandleHit(contact)
    if contact.Name == "ShieldHitbox" then
        self.AiBehavior:DoStun(2)
        return
    end
end

function Enemy:LoadAnimations()
    game:GetService("RunService").Stepped:Wait()
    self.animations["move"] = self.animator:LoadAnimation(ReplicatedStorage.Assets.Animations.Move)
    self.animations["idle"] = self.animator:LoadAnimation(ReplicatedStorage.Assets.Animations.Idle)
    self.animations["attack"] = self.animator:LoadAnimation(ReplicatedStorage.Assets.Animations.Attack)
    self.animations["guard"] = self.animator:LoadAnimation(ReplicatedStorage.Assets.Animations.Guard)

    self.humanoid.Running:Connect(
        function(movementSpeed)
            if movementSpeed > 0 then
                if not self.animations.move.IsPlaying then
                    self.animations.idle:Stop()
                    self.animations.move:Play()
                end
            else
                if self.animations.move.IsPlaying then
                    self.animations.move:Stop()
                    self.animations.idle:Play()
                end
            end
        end
    )
    self.animations.idle:Play()
end

return Enemy
