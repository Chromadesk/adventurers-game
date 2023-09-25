local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Classes.Class)
local Map = Class:Extend()

local RoomAssets = ReplicatedStorage.Assets.Rooms
local RoomClass = require(ReplicatedStorage.Classes.Map.Room)

Map.rooms = nil

function Map:OnNew()
end

function Map:Generate()
    self.rooms = {}
    local i = 1
    while #self.rooms < 2 do
        self.rooms[i] = RoomClass:New(RoomAssets["Miner Guild"])
    end
end

function GetRandomRoom()
    for room in pairs(RoomAssets["Miner Guild"]) do
    end

    if room then
        return room
    end
    GetRandomRoom()
end

return Map
