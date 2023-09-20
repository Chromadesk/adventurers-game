local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage.Remotes
local UIS = game:GetService("UserInputService")

local playerObj = nil
RemoteFolder.GetPlrObj.OnClientEvent:Connect(
    function(playerObj)
        print("recieved")

        local ControlsClass = require(ReplicatedStorage.Classes.Entities.Player.Controls)
        local controls = ControlsClass:New({player = playerObj})

        UIS.InputBegan:Connect(
            function(i, wp)
                controls:FilterInput(i, wp)
            end
        )
    end
)
RemoteFolder.GetPlrObj:FireServer()
