local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage.Remotes
local UIS = game:GetService("UserInputService")
wait(0.25)

local playerObj = nil
RemoteFolder.GetPlrObjList.OnClientEvent:Connect(
    function(playerObjList)
        print("recieved")
        playerObj = playerObjList[game:GetService("Players").LocalPlayer.Name]

        local ControlsClass = require(ReplicatedStorage.Classes.Entities.Player.Controls)
        local controls = ControlsClass:New({player = playerObj})

        UIS.InputBegan:Connect(
            function(i, wp)
                controls:FilterInput(i, wp)
            end
        )
    end
)
RemoteFolder.GetPlrObjList:FireServer()
