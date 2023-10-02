local Class = require(game.ReplicatedStorage.Classes.Class)
local Controls = Class:Extend()

Controls.player = nil

function Controls:OnNew()
    assert(self.player and self.player.reference, "Controls requires a PlayerClass object.")
end

local pauseInput = false
function Controls:InputBegan(input, wasProcessed)
    if wasProcessed or pauseInput or self.player.humanoid.Health <= 0 then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        self.player.attackRemote:FireServer()
    end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name == "E" then
            pauseInput = true
            self.player.guardRemote:FireServer(true)
        end
    end
end

function Controls:InputEnded(input, wasProcessed)
    if wasProcessed then
        return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name == "E" then
            self.player.guardRemote:FireServer(false)
            pauseInput = false
        end
    end
end

return Controls
