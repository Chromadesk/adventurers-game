local PlayerClass = require(game:GetService("ReplicatedStorage").Classes.Player.Player)

local Players = game:GetService("Players")
local dudebro = nil

Players.PlayerAdded:Connect(function(player) dudebro = PlayerClass:New({Reference = player}) end)

print(dudebro.Reference)