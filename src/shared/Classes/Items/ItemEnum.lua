local Weapon = require(game.ReplicatedStorage.Classes.Items.Weapon)
local Shield = require(game.ReplicatedStorage.Classes.Items.Shield)
local ItemAssets = game.ReplicatedStorage.Assets.Items

local ItemEnum = {}

ItemEnum.Weapons = {
    ["LONGSWORD"] = {
        assetFolder = ItemAssets.Longsword,
        attackTime = 0.5,
        cooldown = 0.2,
        damage = 30,
        range = 9
    }
}

ItemEnum.Shields = {
    ["SHIELD"] = {
        assetFolder = ItemAssets.Shield,
        slowAmount = 0.5
    }
}

return ItemEnum
