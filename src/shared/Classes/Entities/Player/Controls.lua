local Class = require(game.ReplicatedStorage.Classes.Class)
local Controls = Class:Extend()

Controls.player = nil

function Controls:OnNew()
    assert(self.player and self.player.reference, "Controls requires a PlayerClass object.")
end

function Controls:FilterInput(input, wasProcessed)
    if wasProcessed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        print("m1")
    end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name == "E" then
            print("e")
        end
    end
end

return Controls
