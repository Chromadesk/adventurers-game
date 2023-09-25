local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local Room = Class:Extend()

Room.name = nil
Room.model = nil
Room.enterDoor = nil
Room.exitDoor = nil

function Room:OnNew()
    assert(self.model, "Room requires a room model")
    assert(self.model:FindFirstChild("EnterDoor", true), "Room requires an EnterDoor")
    assert(self.model:FindFirstChild("ExitDoor", true), "Room requires an ExitDoor")

    self.model = self.model:Clone()
    self.name = self.model.Name
    self.enterDoor = self.model:FindFirstChild("EnterDoor", true)
    self.exitDoor = self.model:FindFirstChild("ExitDoor", true)
end

return Room
