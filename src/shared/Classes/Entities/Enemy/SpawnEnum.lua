local Enemy = require(game.ReplicatedStorage.Classes.Entities.Enemy.Enemy)

local SpawnEnum = {}

SpawnEnum.Enemies = {
    ["Bandit"] = Enemy:New(
        {name = "Bandit", assetFolder = game.ReplicatedStorage.Assets.Enemies["Bandit"], maxHealth = 75, maxSpeed = 16}
    )
}

SpawnEnum.DevSpawnTable = {
    SpawnEnum.Enemies.Bandit
}

return SpawnEnum
