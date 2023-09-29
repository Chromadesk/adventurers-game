local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local World = Class:Extend()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local GamePlayerClass = require(ReplicatedStorage.Classes.Entities.Player.GamePlayer)
local Map = require(ReplicatedStorage.Classes.Map.Map)
local RemoteFolder = ReplicatedStorage.Remotes

--All lists are filled with class objects, not roblox objects
World.playerList = {}

function World:OnNew()
    self:RemoveRegen()
    self:InitializePlayerList()
    Map:Generate()
end

function World:InitializePlayerList()
    PlayerService.PlayerAdded:Connect(
        function(player)
            print(player.Name .. " joined.")
            player.CharacterAdded:Connect(
                function(a)
                    self.playerList[player.Name] =
                        GamePlayerClass:New({reference = player, maxHealth = 100, maxSpeed = 16})
                    RemoteFolder.LoadAnimations:FireClient(player, self.playerList[player.Name])
                end
            )
        end
    )
    PlayerService.PlayerRemoving:Connect(
        function(player)
            self.playerList[player.Name] = nil
            print(player.Name .. " disconnected.")
        end
    )

    RemoteFolder.GetPlrObj.OnServerEvent:Connect(
        function(player)
            while not self.playerList[player.Name] do
                wait()
            end
            RemoteFolder.GetPlrObj:FireClient(player, self.playerList[player.Name])
        end
    )
end

function World:RemoveRegen()
    game.Workspace.DescendantAdded:connect(
        function(des)
            wait(1)
            if des == nil then
                return
            end
            if des:IsA("Script") and des.Name == "Health" then
                if des == nil then
                    return
                end
                des:remove()
            end
        end
    )
end

function World:GetPlayer(name)
    return self.playerList[name]
end

function World:GetPlayerList()
    return self.playerList
end

return World
