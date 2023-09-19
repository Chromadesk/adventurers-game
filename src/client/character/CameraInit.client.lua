local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local CameraClass = require(ReplicatedStorage.Classes.Entities.Player.Camera)
local camera = CameraClass:New({player = player, target = player.Character.HumanoidRootPart})

RunService.RenderStepped:Connect(
    function(a)
        camera:Update()
    end
)
