local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local character = nil

local target = nil

player.CharacterAdded:Connect(function()
    character = player.Character
    target = Instance.new("Part")
    target.Shape = "Ball"
    target.Anchored = true
    target.Name = player.Name .." Ball"
    target.CanCollide = false
    target.Material = "SmoothPlastic"
    target.Transparency = 0.5
    target.Parent = workspace
    target.CFrame = workspace.robert.CFrame

    character:WaitForChild("Humanoid").Died:Connect(function() target:Destroy() end)
    character.Humanoid.WalkSpeed = 0
end)

camera.CameraSubject = target
camera.CameraType = Enum.CameraType.Scriptable

runService.RenderStepped:Connect(function()
	if not target then return end

    if UserInputService:IsKeyDown("W") then target.Position = target.Position + Vector3.new(1, 0, 0) end
    if UserInputService:IsKeyDown("S") then target.Position = target.Position - Vector3.new(1, 0, 0) end
    if UserInputService:IsKeyDown("A") then target.Position = target.Position - Vector3.new(0, 0, 1) end
    if UserInputService:IsKeyDown("D") then target.Position = target.Position + Vector3.new(0, 0, 1) end
	camera.CFrame = CFrame.new(target.Position) * CFrame.new(Vector3.new(0, 20, 0), Vector3.new(0.1, 0, 0))
end)