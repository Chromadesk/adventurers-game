--Instances of this class never are destroyed. Bad no good very not epic.
--Maids may be the solution.

local Class = require(game.ReplicatedStorage.Classes.Class)
local AiBehavior = Class:Extend()

AiBehavior.type = nil
AiBehavior.NPC = nil
AiBehavior.FollowPart = nil
AiBehavior.isNPCStunned = nil
AiBehavior.attackChance = nil
AiBehavior.FollowLimit = nil

function AiBehavior:OnNew()
    assert(self.NPC, "AiBehavior must have an Enemy Class object.")
    self.NPC.AiBehavior = self
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

    local update = 0
    local updateTime = 16 / self.NPC.humanoid.WalkSpeed
    while wait() and self.NPC.humanoid.Health > 0 and character and character.Humanoid.Health > 0 do
        if update >= updateTime or GetTargetDistance(self.NPC.model.HumanoidRootPart, self.FollowPart) <= 1 then
            self.FollowPart.CFrame =
                character.HumanoidRootPart.CFrame *
                CFrame.new(math.random(-10, 10), 0, -math.random(self.NPC.weapon.range / 2, self.NPC.weapon.range + 5))
            update = 0
        end
        self:OrientNPC(self.NPC.model, character.HumanoidRootPart.Position)
        self.NPC.humanoid:MoveTo(self.FollowPart.Position)
        if distance <= self.NPC.weapon.range then
            self:TryAttack()
        end
        update = update + 0.05
        character, distance = self:GetClosestPlayer(self.NPC.model)
    end
    self:Idle()
    return
end

function AiBehavior:Idle()
    if self.NPC.humanoid.Health <= 0 then
        return
    end
    self.NPC.humanoid.WalkSpeed = self.NPC.maxSpeed * 0.5
    repeat
        local character = self:GetClosestPlayer(self.NPC.model)
        wait(0.1)
    until character
    self:FollowPlayer()
    return
end

function AiBehavior:TryAttack()
    if self.isStunned or math.random(0, 100) < self.attackChance then
        return
    end

    self.NPC.weapon:Use(self.NPC)
end

function AiBehavior:DoStun(time)
    self.isStunned = true
    self.NPC.humanoid.WalkSpeed = 2
    wait(time)
    self.isStunned = false
    self.NPC.humanoid.WalkSpeed = self.NPC.maxSpeed
    self:Idle()
end

function AiBehavior:SetupFollowPart()
    self.FollowPart = Instance.new("Part")
    self.FollowPart.Name = "FollowPart"
    self.FollowPart.Anchored = true
    self.FollowPart.CanCollide = false
    self.FollowPart.Transparency = 1
    self.FollowPart.Parent = self.NPC.model
end

function AiBehavior:SetMeleeAi()
    self.FollowLimit = 10
    self.attackChance = 30

    self:SetupFollowPart()
    self:Idle()
end

function AiBehavior:OrientNPC(model, position)
    local HRP = model.HumanoidRootPart
    HRP.CFrame = CFrame.new(HRP.CFrame.Position, Vector3.new(position.X, HRP.CFrame.Position.Y, position.Z))
end

return AiBehavior
