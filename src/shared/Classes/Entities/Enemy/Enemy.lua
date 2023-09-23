local Class = require(game.ReplicatedStorage.Classes.Class)
local Enemy = Class:Extend()
local AiBehaviorClass = require(game.ReplicatedStorage.Classes.Entities.Enemy.AiBehavior)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponClass = require(ReplicatedStorage.Classes.Items.Weapon)

Enemy.name = nil
Enemy.maxHealth = nil
Enemy.maxSpeed = nil
Enemy.model = nil
Enemy.animator = nil
Enemy.humanoid = nil
Enemy.AiBehavior = nil
Enemy.animations = nil
Enemy.weapon = nil
Enemy.shield = nil

function Enemy:OnNew()
    assert(self.name, "Enemy must have a name.")
    assert(self.assetFolder, "Enemy must have an assetFolder.")
    assert(self.assetFolder[self.name], "Enemy's assetFolder must have a Model.")
    assert(self.assetFolder.Stats, "Enemy's assetFolder must have a Stats folder.")

    self.assetFolder = self.assetFolder:Clone()
    self.model = self.assetFolder[self.name]
    self.humanoid = self.model.Humanoid
    self.animator = self.humanoid.Animator
    self.maxHealth = self.assetFolder.Stats.Health.Value
    self.maxSpeed = self.assetFolder.Stats.Speed.Value

    self.humanoid.Died:Connect(
        function()
            self:OnDied()
        end
    )

    self:EquipWeapon(WeaponClass:New({assetFolder = ReplicatedStorage.Assets.Items.Longsword}))
end

function Enemy:TakeDamage(dam)
    self.humanoid.Health = self.humanoid.Health - dam
end

function Enemy:OnDied()
    wait(5)
    self.model:Destroy()
    self.assetFolder:Destroy()
end

function Enemy:HandleHit(contact)
    if contact.Name == "ShieldHitbox" then
        print("stunnin cuz i hit da sheld")
        self.AiBehavior:DoStun(2.5)
        return
    end
end

function Enemy:EquipWeapon(weapon)
    self.weapon = weapon

    weapon:Equip(self)
end

function Enemy:EquipShield(shield)
    self.shield = shield

    shield:Equip(self)
end

function Enemy:Spawn(spawnPos)
    self.model.Parent = workspace.NPCs
    self:LoadAnimations()
    self.model:MoveTo(spawnPos)
    self.AiBehavior = AiBehaviorClass:New({NPC = self})
end

function Enemy:LoadAnimations()
    self.animations = {}
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
