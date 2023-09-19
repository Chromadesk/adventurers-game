local Class = require(game.ReplicatedStorage.Classes.Class)
local Camera = Class:Extend()

Camera.player = nil
Camera.target = nil
Camera.camera = nil

function Camera:OnNew()
    assert(self.player, "Camera requires a ROBLOX player object.")
    assert(self.target, "Camera requires a ROBLOX Part target.")

    self.camera = workspace.CurrentCamera
    self.camera.CameraSubject = self.target
    self.camera.CameraType = Enum.CameraType.Scriptable
end

function Camera:Update()
    if not self.target then
        return
    end
    self.camera.CFrame = CFrame.new(self.target.Position) * CFrame.new(Vector3.new(0, 30, 0), Vector3.new(0.1, 0, 0))
end

return Camera
