local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage.Remotes

local PlayerClass = require(ReplicatedStorage.Classes.Entities.Player.Player)
local WeaponClass = require(ReplicatedStorage.Classes.Items.Weapon)

local Players = game:GetService("Players")
local plrObjList = {}

Players.PlayerAdded:Connect(
    function(player)
        plrObjList[player.Name] = PlayerClass:New({reference = player, health = 100, speed = 16})
        print(plrObjList[player.Name])
        RemoteFolder.LoadAnimations:FireClient(player, plrObjList[player.Name])
    end
)

Players.PlayerRemoving:Connect(
    function(player)
        plrObjList[player.Name] = nil
    end
)

RemoteFolder.GetPlrObj.OnServerEvent:Connect(
    function(player)
        while not plrObjList[player.Name] do
            wait()
        end
        RemoteFolder.GetPlrObj:FireClient(player, plrObjList[player.Name])
    end
)
