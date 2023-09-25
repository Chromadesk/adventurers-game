local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local HitDetection = Class:Extend()
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

function HitDetection:OnNew()
end

--Extends outward quickly so possible conflicts such as hitting a shield and player at the same time don't happen
function HitDetection:MakeRectangleHitbox(entity, range, damage)
    local hitbox = GetHitbox(entity, Vector3.new(3 * (range / 100 + 1), 1, 0.1), damage)
    hitbox.CFrame = entity.model.HumanoidRootPart.CFrame
    hitbox.CFrame = hitbox.CFrame:ToWorldSpace(CFrame.new(0, 0, -range / 2))
    hitbox.weld.Part1 = entity.model.HumanoidRootPart

    local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
    local tweenGoal = {Size = hitbox.Size + Vector3.new(0, 0, range - 0.1)}
    local tween = TweenService:Create(hitbox, tweenInfo, tweenGoal)

    hitbox.Parent = entity.model
    tween:Play()
    wait(0.05)
    hitbox:Destroy()
end

function HitDetection:MakeShieldHitbox(model, range)
    local hitbox = GetHitbox(model, Vector3.new(4, 8, 1))
    hitbox.CFrame = model.HumanoidRootPart.CFrame
    hitbox.CFrame = hitbox.CFrame:ToWorldSpace(CFrame.new(0, 0, -2))
    hitbox.weld.Part1 = model.HumanoidRootPart
    hitbox.Name = "ShieldHitbox"

    hitbox.Parent = model
    return hitbox
end

function HitDetection:InitializeCollisionBox(character)
    local colbox = Instance.new("Part")
    colbox.CollisionGroup = "Entity"
    colbox.Shape = "Cylinder"
    colbox.Size = Vector3.new(5, 5, 5)
    colbox.Transparency = 1
    colbox.Anchored = false
    colbox.CanTouch = false
    colbox.Name = "CollisionBox"
    colbox.Parent = character
    colbox.Position = character.HumanoidRootPart.Position
    colbox.Orientation = Vector3.new(0, 0, 90)
    colbox.CFrame = colbox.CFrame:ToWorldSpace(CFrame.new(0, 0, 0.5))
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = colbox
    weld.Part1 = character.HumanoidRootPart
    weld.Parent = colbox
end

function GetHitbox(entity, size, damage)
    local hitbox = Instance.new("Part")
    hitbox.Transparency = 1
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.Size = size
    hitbox.Name = "Hitbox"

    local weld = Instance.new("WeldConstraint")
    weld.Name = "weld"
    weld.Part0 = hitbox
    weld.Parent = hitbox

    if damage then
        local debounce = false
        local function onTouch(toucher)
            local hum = FindHumanoid(toucher)
            if debounce or toucher:IsDescendantOf(entity.model) or not hum then
                return
            end
            debounce = true
            if IsNotHittingShield(hitbox) and toucher.Name ~= "ShieldHitbox" then
                hum:TakeDamage(damage)
            end
            entity:HandleHit(toucher)
            hitbox:Destroy()
        end
        hitbox.Touched:Connect(onTouch)
    end

    return hitbox
end

function FindHumanoid(obj)
    local folder = obj.Parent
    while folder.Name ~= "Workspace" and not folder:IsA("Accessory") do
        if folder:FindFirstChild("Humanoid") then
            return folder.Humanoid
        end
        folder = folder.Parent
    end
    return nil
end

function IsNotHittingShield(hitbox)
    for _, v in pairs(workspace:GetPartsInPart(hitbox)) do
        if v.Name == "ShieldHitbox" then
            return false
        end
    end
    return true
end

return HitDetection
