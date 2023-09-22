local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Weapon = Class:Extend()

Weapon.assetFolder = nil
Weapon.statsFolder = nil
Weapon.attackTime = nil
Weapon.cooldown = nil
Weapon.damage = nil
Weapon.range = nil
Weapon.model = nil

function Weapon:OnNew()
    assert(self.assetFolder, "Weapons must have an asset folder with their included data.")
    assert(self.assetFolder.Animations, "Weapon asset folder must have an animations folder, even if it is empty.")
    assert(self.assetFolder.Stats, "Weapon asset folder must have a stats folder even if it is empty.")
    assert(self.assetFolder.Stats.AttackTime, "Weapon must have an AttackTime stat.")
    assert(self.assetFolder.Stats.Cooldown, "Weapon must have a Cooldown stat.")
    assert(self.assetFolder.Stats.Damage, "Weapon must have a Damage stat.")
    assert(self.assetFolder.Stats.Range, "Weapon must have a Range stat.")

    self.assetFolder = self.assetFolder:Clone()
    self.statsFolder = self.assetFolder.Stats
    self.attackTime = self.statsFolder.AttackTime.Value
    self.cooldown = self.statsFolder.Cooldown.Value
    self.damage = self.statsFolder.Damage.Value
    self.range = self.statsFolder.Range.Value
    self.model = self.assetFolder.Model

    self:IntializeModel()
end

function Weapon:Equip(player)
    self.assetFolder.Parent = player.model
end

function Weapon:IntializeModel()
    self.model.CanCollide = false
    self.model.Anchored = false

    local handle = self.assetFolder.Handle
    handle.CanCollide = false
    handle.Anchored = false
    handle.Transparency = 1
end

local onCooldown = false
function Weapon:Use(player)
    if onCooldown then
        return
    end
    onCooldown = true
    player.animations.attack:Play()
    wait(self.attackTime / 2)

    local hitbox = getHitbox(player.model, self.range, self.damage)
    hitbox.CFrame = player.model.HumanoidRootPart.CFrame
    hitbox.CFrame = hitbox.CFrame:ToWorldSpace(CFrame.new(0, 0, -self.range / 2))
    hitbox.weld.Part1 = player.model.HumanoidRootPart
    hitbox.Parent = workspace
    wait(0.05)
    hitbox:Destroy()

    wait(self.attackTime / 2 + self.cooldown)
    player.animations.attack:Stop()
    onCooldown = false
end

function getHitbox(playerModel, range, damage)
    local hitbox = Instance.new("Part")
    hitbox.Transparency = 0
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.Size = Vector3.new(3 * (range / 100 + 1), 1, range)
    local weld = Instance.new("WeldConstraint")
    weld.Name = "weld"
    weld.Part0 = hitbox
    weld.Parent = hitbox

    local function onTouch(toucher)
        local hum = findHumanoid(toucher)
        if toucher:IsDescendantOf(playerModel) or not hum then
            return
        end
        hum:TakeDamage(damage)
        hitbox:Destroy()
    end
    hitbox.Touched:Connect(onTouch)

    return hitbox
end

function findHumanoid(obj)
    local folder = obj.Parent
    while folder.Name ~= "Workspace" do
        if folder:FindFirstChild("Humanoid") then
            return folder.Humanoid
        end
        folder = folder.Parent
    end
    return nil
end

return Weapon
