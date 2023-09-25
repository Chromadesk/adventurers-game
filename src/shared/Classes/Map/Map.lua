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
    local i = 1
    while #self.rooms < 5 do
        self.rooms[i] = RoomClass:New({model = GetRandomRoom()})
        Map:AddRoom(self.rooms[i])
        i = i + 1
    end
    print(self.rooms)
end

function GetRandomRoom()
    local r = RoomAssets:WaitForChild("Miner Guild"):GetChildren()
    return r[math.round(math.random(1, #r))]
end

function Map:AddRoom(room)
    room.model.Parent = workspace
    room.model:MoveTo(self.placePart.Position)
    self.placePart.Position = self.placePart.Position + Vector3.new(0, 0, 50)
end

return Map
