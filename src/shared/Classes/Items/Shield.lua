local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Shield = Class:Extend()

local HitDetection = require(game:GetService("ReplicatedStorage").Classes.HitDetection)

function Shield:OnNew()
    assert(self.assetFolder, "Shields must have an asset folder with their included data.")
    assert(self.assetFolder.Animations, "Shield asset folder must have an animations folder, even if it is empty.")
    assert(self.slowAmount, "Shield must have an slowAmount stat.")

    self.assetFolder = self.assetFolder:Clone()
    self.model = self.assetFolder.Model

    self:IntializeModel()
end

function Shield:Equip(entity)
    self.assetFolder.Parent = entity.model
end

function Shield:IntializeModel()
    self.model.CanCollide = false
    self.model.Anchored = false

    local handle = self.assetFolder.Handle
    handle.CanCollide = false
    handle.Anchored = false
    handle.Transparency = 1
end

local hitbox = nil
function Shield:Use(entity, isActive)
    if not isActive then
        entity.animations.guard:Stop()
        entity.humanoid.WalkSpeed = entity.maxSpeed
        hitbox:Destroy()
        entity.model.ArmLUpper.CanTouch = true
        entity.model.ArmLLower.CanTouch = true
        entity.model.HandL.CanTouch = true
        return
    end
    entity.animations.guard:Play()
    entity.humanoid.WalkSpeed = entity.maxSpeed * self.slowAmount
    hitbox = HitDetection:MakeShieldHitbox(entity.model, self.range)
    entity.model.ArmLUpper.CanTouch = false
    entity.model.ArmLLower.CanTouch = false
    entity.model.HandL.CanTouch = false
end

return Shield
