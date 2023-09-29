local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Classes.Class)
local Map = Class:Extend()

local RoomAssets = ReplicatedStorage.Assets.Rooms
local RoomClass = require(ReplicatedStorage.Classes.Map.Room)

Map.rooms = nil
Map.placePart = workspace.Map.MapPlacePart

function Map:OnNew()
end

function Map:Generate()
    self.rooms = {}
    local i = 2
    self.rooms[1] = RoomClass:New({model = GetRandomRoom(), index = 1, isSpawnRoom = true})
    Map:AddRoom(self.rooms[1])
    Map:HandleRoomUnlocking(self.rooms[1])
    while #self.rooms < 5 do
        self.rooms[i] = RoomClass:New({model = GetRandomRoom(), index = i})
        Map:AddRoom(self.rooms[i])
        Map:HandleRoomUnlocking(self.rooms[i])
        self.rooms[i]:SpawnEnemies()
        i = i + 1
    end
end

function GetRandomRoom()
    local list = RoomAssets:WaitForChild("Miner Guild"):GetChildren()
    return list[math.round(math.random(1, #list))]
end

function Map:AddRoom(room)
    room.model.Parent = workspace.Map
    room.model:SetPrimaryPartCFrame(self.placePart.CFrame)
    self.placePart.Position = self.placePart.Position + Vector3.new(0, 0, 50)
end

function Map:HandleRoomUnlocking(room)
    local room = self.rooms[room.index]
    room.enterDoor.CanCollide = false
    room.enterDoor.Transparency = 1

    room.exitDoor.touched:Connect(
        function(t)
            print(room.enemies)
            if #room.enemies > 0 then
                return
            end
            room.exitDoor.CanCollide = false
            room.exitDoor.CanTouch = false
            room.exitDoor.Transparency = 1

            self.rooms[room.index + 1]:Unlock()
        end
    )
end

return Map
