local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Shield = Class:Extend()

local HitDetection = require(game:GetService("ReplicatedStorage").Classes.HitDetection)

Shield.assetFolder = nil
Shield.statsFolder = nil
Shield.slowAmount = nil
Shield.model = nil

function Shield:OnNew()
    assert(self.assetFolder, "Shields must have an asset folder with their included data.")
    assert(self.assetFolder.Animations, "Shield asset folder must have an animations folder, even if it is empty.")
    assert(self.assetFolder.Stats, "Shield asset folder must have a stats folder even if it is empty.")
    assert(self.assetFolder.Stats.SlowAmount, "Shield must have an SlowAmount stat.")

    self.assetFolder = self.assetFolder:Clone()
    self.statsFolder = self.assetFolder.Stats
    self.slowAmount = self.statsFolder.SlowAmount.Value
    self.model = self.assetFolder.Model

    self:IntializeModel()
end

function Shield:Equip(player)
    self.assetFolder.Parent = player.model
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
function Shield:Use(player, isActive)
    if not isActive then
        player.animations.guard:Stop()
        player.humanoid.WalkSpeed = player.maxSpeed
        hitbox:Destroy()
        return
    end
    player.animations.guard:Play()
    player.humanoid.WalkSpeed = player.maxSpeed * (self.slowAmount / 100)
    hitbox = HitDetection:MakeShieldHitbox(player.model, self.range)
end

return Shield
