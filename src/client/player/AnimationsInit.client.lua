local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage.Remotes

function loadAnimations(player)
    player.animations["move"] = player.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Move)
    player.animations["idle"] = player.humanoid:LoadAnimation(ReplicatedStorage.Assets.Animations.Idle)

    player.humanoid.Running:Connect(
        function(movementSpeed)
            if movementSpeed > 0 then
                if not player.animations.move.IsPlaying then
                    player.animations.idle:Stop()
                    player.animations.move:Play()
                end
            else
                if player.animations.move.IsPlaying then
                    player.animations.move:Stop()
                    player.animations.idle:Play()
                end
            end
        end
    )
    player.animations.idle:Play()
end
RemoteFolder.LoadAnimations.OnClientEvent:Connect(
    function(player)
        print(player)
        loadAnimations(player)
    end
)
