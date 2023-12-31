local Debris = game:GetService("Debris")

local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local HitDetection = Class:Extend()

function HitDetection:OnNew()
end

--Extends outward quickly so possible conflicts such as hitting a shield and player at the same time don't happen
function HitDetection:MakeRectangleHitbox(entity, range, damage)
    local hitbox = GetHitbox(entity, Vector3.new(3 * (range / 100 + 1), 1, range), damage)
    hitbox.CFrame = entity.model.HumanoidRootPart.CFrame
    hitbox.CFrame = hitbox.CFrame:ToWorldSpace(CFrame.new(0, 0, -range / 2))
    hitbox.weld.Part1 = entity.model.HumanoidRootPart

    hitbox.Parent = entity.model
    Debris:AddItem(hitbox, 0.05)
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
    hitbox.Transparency = 0.5
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
            if
                debounce or toucher:IsDescendantOf(entity.model) or not hum or
                    hum:GetAttribute("TeamTag") == entity.humanoid:GetAttribute("TeamTag")
             then
                return
            end
            debounce = true
            local isShield, shieldPart = IsHittingShield(hitbox)
            if isShield or toucher.Name == "ShieldHitbox" then
                entity:HandleHit(shieldPart)
            else
                hum:TakeDamage(damage)
                entity:HandleHit(toucher)
            end

            hitbox:Destroy()
        end
        hitbox.Touched:Connect(onTouch)
    end

    return hitbox
end

function FindHumanoid(obj)
    local folder = obj.Parent
    --somehow its hitting things without parents sometimes??
    while folder and folder.Name ~= "Workspace" and not folder:IsA("Accessory") do
        if folder:FindFirstChild("Humanoid") then
            return folder.Humanoid
        end
        folder = folder.Parent
    end
    return nil
end

function IsHittingShield(hitbox)
    for _, v in pairs(workspace:GetPartsInPart(hitbox)) do
        if v.Name == "ShieldHitbox" then
            return true, v
        end
    end
    return false
end

return HitDetection
