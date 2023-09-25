local Class = require(ReplicatedStorage.Classes.Class)
local Room = Class:Extend()

Room.model = nil
Room.enterDoor = nil
Room.exitDoor = nil

function Room:OnNew()
    assert(self.model, "Room requires a room model")
    assert(self.model.EnterDoor, "Room requires an EnterDoor")
    assert(self.model.ExitDoor, "Room requires an ExitDoor")

    self.enterDoor = self.model.EnterDoor
    self.exitDoor = self.model.ExitDoor
end

return Room
