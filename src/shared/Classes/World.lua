local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local World = Class:Extend()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local PlayerClass = require(ReplicatedStorage.Classes.Entities.Player.Player)
local EnemyClass = require(ReplicatedStorage.Classes.Entities.Enemy.Enemy)
local RemoteFolder = ReplicatedStorage.Remotes

--All lists are filled with class objects, not roblox objects
World.playerList = {}
World.enemyList = {}

function World:OnNew()
    self:RemoveRegen()
    self:InitializePlayerList()
    self:Dev_SpawnEnemy("Bandit")
end
function World:InitializePlayerList()
    PlayerService.PlayerAdded:Connect(
        function(player)
            self.playerList[player.Name] = PlayerClass:New({reference = player, maxHealth = 100, maxSpeed = 16})
            print(player.Name .. " joined.")
            RemoteFolder.LoadAnimations:FireClient(player, self.playerList[player.Name])
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

function World:GetEnemy(name)
    return self.enemyList[name]
end

function World:GetEnemyList()
    return self.enemyList
end

--Will be replaced later.
function World:Dev_SpawnEnemy(name)
    self.enemyList[name] = EnemyClass:New({name = name, assetFolder = ReplicatedStorage.Assets.Enemies[name]})
    self.enemyList[name].model.Destroying:Connect(
        function()
            wait(1)
            self.enemyList[name] = nil
        end
    )

    self.enemyList[name]:Spawn(workspace.EnemySpawn.Position)
end

return World
