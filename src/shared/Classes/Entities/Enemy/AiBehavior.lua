local Class = require(game.ReplicatedStorage.Classes.Class)
local AiBehavior = Class:Extend()

function AiBehavior:OnNew()
end

--If visible is true, will only return value if there are no obstructions between origin and target.
function GetTargetDistance(target, origin)
    if not target then
        return nil
    end
    local toTarget = target.Position - origin.Position
    local toTargetRay = Ray.new(origin.Position, toTarget)
    local part = game.Workspace:FindPartOnRay(toTargetRay, origin, false, false)
    ---------------This would account for obstructions between the origin and the target by returning nil
    -- if part and part:IsDescendantOf(target.Parent) or part and part:IsDescendantOf(origin.Parent) then
    --     return toTarget.magnitude
    -- end
    -- return nil
    return toTarget.magnitude
end

function AiBehavior:GetClosestPlayer(model)
    local closestDistance = math.huge
    local closestCharacter = nil
    local closestAngle = nil

    for _, character in pairs(workspace.PlayerCharacters:GetChildren()) do
        if character and character.Humanoid.Health > 0 then
            local distance = GetTargetDistance(character.Head, model.Head)
            if distance and distance < closestDistance then
                closestDistance = distance
                closestCharacter = character
                closestAngle = (character.ChestUpper.CFrame:inverse() * model.HumanoidRootPart.CFrame).Z
            end
        end
    end
    return closestCharacter, closestDistance, closestAngle
end

return AiBehavior
