local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Shield = Class:Extend()

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
        player.humanoid.WalkSpeed = player.speed
        hitbox:Destroy()
        return
    end
    player.animations.guard:Play()
    player.humanoid.WalkSpeed = player.speed * (self.slowAmount / 100)
    hitbox = getHitbox(player.model, self.range)
    hitbox.CFrame = player.model.HumanoidRootPart.CFrame
    hitbox.CFrame = hitbox.CFrame:ToWorldSpace(CFrame.new(0, 0, -2.5))
    hitbox.weld.Part1 = player.model.HumanoidRootPart
    hitbox.Parent = workspace
end

function getHitbox(player)
    local hitbox = Instance.new("Part")
    hitbox.Transparency = 0
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.Size = Vector3.new(4, 8, 1)
    local weld = Instance.new("WeldConstraint")
    weld.Name = "weld"
    weld.Part0 = hitbox
    weld.Parent = hitbox

    return hitbox
end

return Shield
