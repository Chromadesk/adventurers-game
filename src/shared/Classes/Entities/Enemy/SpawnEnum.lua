local Enemy = require(game.ReplicatedStorage.Classes.Entities.Enemy.Enemy)
local ItemEnum = require(game.ReplicatedStorage.Classes.Items.ItemEnum)
local EnemyAssets = game.ReplicatedStorage.Assets.Enemies

local SpawnEnum = {}

SpawnEnum.Enemies = {
    ["BANDIT"] = {
        name = "Bandit",
        assetFolder = EnemyAssets.Bandit,
        maxHealth = 75,
        maxSpeed = 16,
        weapon = ItemEnum.Weapons.LONGSWORD,
        shield = ItemEnum.Shields.SHIELD
    }
}

SpawnEnum.DevSpawnTable = {
    SpawnEnum.Enemies.BANDIT
}

return SpawnEnum
