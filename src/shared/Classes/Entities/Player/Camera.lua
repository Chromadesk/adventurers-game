local Class = require(game.ReplicatedStorage.Classes.Class)
local Camera = Class:Extend()

Camera.player = nil
Camera.target = nil
Camera.camera = nil
Camera.playerHRP = nil
Camera.mouse = nil

function Camera:OnNew()
    assert(self.player and self.player:IsA("Player"), "Camera requires a ROBLOX player object.")
    assert(self.mouse and self.mouse:IsA("Mouse"), "Camera requires a ROBLOX player's Mouse object.")
    assert(self.target and self.target:IsA("Part"), "Camera requires a ROBLOX Part target.")

    self.camera = workspace.CurrentCamera
    self.camera.CameraSubject = self.target
    self.camera.CameraType = Enum.CameraType.Scriptable
    self.playerHRP = self.player.Character.HumanoidRootPart
end

function Camera:Update()
    if not self.target then
        return
    end
    self.camera.CFrame = CFrame.new(self.target.Position) * CFrame.new(Vector3.new(0, 30, 0), Vector3.new(0.1, 0, 0))
    self.playerHRP.CFrame =
        CFrame.lookAt(
        self.playerHRP.CFrame.Position,
        Vector3.new(self.mouse.Hit.Position.X, self.playerHRP.CFrame.Position.Y, self.mouse.Hit.Position.Z)
    )
end

return Camera
