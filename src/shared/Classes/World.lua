local Class = require(game:GetService("ReplicatedStorage").Classes.Class)
local World = Class:Extend()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local GamePlayerClass = require(ReplicatedStorage.Classes.Entities.Player.GamePlayer)
local Map = require(ReplicatedStorage.Classes.Map.Map)
local ItemEnum = require(ReplicatedStorage.Classes.Items.ItemEnum)
local RemoteFolder = ReplicatedStorage.Remotes

--All lists are filled with class objects, not roblox objects
World.playerList = {}
World.objects = {}

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
                function()
                    self.playerList[player.Name] =
                        GamePlayerClass:New(
                        {
                            name = player.Name,
                            assetFolder = player,
                            model = workspace:WaitForChild(player.Name),
                            maxHealth = 100,
                            maxSpeed = 16,
                            weapon = ItemEnum.Weapons.LONGSWORD,
                            shield = ItemEnum.Shields.SHIELD
                        }
                    )
                    self.playerList[player.Name]:Initialize()
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

function World:AddObject(object)
    if object.humanoid then
        object.humanoid.Died:Connect(
            function()
                self:RemoveObject(object)
            end
        )
    end
    table.insert(self.objects, object)
end

function World:RemoveObject(object)
    table.remove(self.objects, table.find(self.objects, object))
end

function World:GetObjectById(id)
    for _, v in pairs(self.objects) do
        if v.id == id then
            return v
        end
    end
    return nil
end

function World:GetObjectByHumanoid(humanoid)
    for _, v in pairs(self.objects) do
        if v.humanoid and v.humanoid == humanoid then
            return v
        end
    end
    return nil
end

return World
