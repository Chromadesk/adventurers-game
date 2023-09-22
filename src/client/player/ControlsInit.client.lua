local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage.Remotes
local UIS = game:GetService("UserInputService")

local playerObj = nil
RemoteFolder.GetPlrObj.OnClientEvent:Connect(
    function(playerObj)
        local ControlsClass = require(ReplicatedStorage.Classes.Entities.Player.Controls)
        local controls = ControlsClass:New({player = playerObj})

        UIS.InputBegan:Connect(
            function(i, wp)
                controls:InputBegan(i, wp)
            end
        )
        UIS.InputEnded:Connect(
            function(i, wp)
                controls:InputEnded(i, wp)
            end
        )
    end
)
RemoteFolder.GetPlrObj:FireServer()
