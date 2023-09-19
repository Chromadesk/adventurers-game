local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage.Remotes
local UIS = game:GetService("UserInputService")

function filterInput(input, wasProcessed)
    if wasProcessed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        print("m1")
    end
end
UIS.InputBegan:Connect(filterInput)
