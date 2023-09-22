local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local HitDetection = Class:Extend()
local TweenService = game:GetService("TweenService")

function HitDetection:OnNew()
end

--Extends outward quickly so possible conflicts such as hitting a shield and player at the same time don't happen
function HitDetection:MakeRectangleHitbox(model, range, damage)
    local hitbox = getHitbox(model, range, damage)
    hitbox.CFrame = model.HumanoidRootPart.CFrame
    hitbox.CFrame = hitbox.CFrame:ToWorldSpace(CFrame.new(0, 0, -range / 2))
    hitbox.weld.Part1 = model.HumanoidRootPart

    local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
    local tweenGoal = {Size = hitbox.Size + Vector3.new(0, 0, range - 0.1)}
    local tween = TweenService:Create(hitbox, tweenInfo, tweenGoal)

    hitbox.Parent = workspace
    tween:Play()
    wait(0.05)
    hitbox:Destroy()
end

function getHitbox(playerModel, range, damage)
    local hitbox = Instance.new("Part")
    hitbox.Transparency = 0
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.Size = Vector3.new(3 * (range / 100 + 1), 1, 0.1)
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

return HitDetection
