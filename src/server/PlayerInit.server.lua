local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage.Remotes

local PlayerClass = require(ReplicatedStorage.Classes.Entities.Player.Player)
local WeaponClass = require(ReplicatedStorage.Classes.Items.Weapon)

local Players = game:GetService("Players")
local dudebro = nil

Players.PlayerAdded:Connect(
    function(player)
        dudebro = PlayerClass:New({reference = player, health = 100, speed = 16})
    end
)
