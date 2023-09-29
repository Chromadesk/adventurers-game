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
    self.rooms[1] = RoomClass:New({model = GetRandomRoom(), isSpawnRoom = true})
    Map:AddRoom(self.rooms[1])
    while #self.rooms < 5 do
        self.rooms[i] = RoomClass:New({model = GetRandomRoom()})
        Map:AddRoom(self.rooms[i])
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

return Map
