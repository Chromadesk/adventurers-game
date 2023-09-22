local Class = require(game.ReplicatedStorage.Classes.Class)
local AiBehavior = Class:Extend()

AiBehavior.type = nil
AiBehavior.NPC = nil
AiBehavior.FollowPart = nil

AiBehavior.FollowLimit = nil

function AiBehavior:OnNew()
    assert(self.NPC, "AiBehavior must have an Enemy Class object.")
    self:SetMeleeAi()
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

function AiBehavior:FollowPlayer()
    self.NPC.humanoid.WalkSpeed = self.NPC.maxSpeed
    local character, distance = self:GetClosestPlayer(self.NPC.model)
    while character and wait(0.0001) do
        self.FollowPart.CFrame = character.HumanoidRootPart.CFrame
        self.NPC.humanoid:MoveTo(self.FollowPart.Position)
    end
    self:Idle()
    return
end

function AiBehavior:Idle()
    print(self.NPC)
    print(self.NPC.maxSpeed)
    self.NPC.humanoid.WalkSpeed = self.NPC.maxSpeed * 0.5
    repeat
        local character = self:GetClosestPlayer(self.NPC.model)
        wait(0.1)
    until character
    self:FollowPlayer()
    return
end

function AiBehavior:SetupFollowPart()
    self.FollowPart = Instance.new("Part")
    self.FollowPart.Name = "FollowPart"
    self.FollowPart.Anchored = false
    self.FollowPart.CanCollide = false
    self.FollowPart.Transparency = 0.5
    self.FollowPart.Parent = self.NPC.model
end

function AiBehavior:SetMeleeAi()
    AiBehavior.FollowLimit = 10

    self:SetupFollowPart()
    self:Idle()
end

return AiBehavior
