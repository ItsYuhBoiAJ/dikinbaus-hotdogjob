Config = Config or {}

-- General Settings
Config.UseTarget = false  -- No need for target system
Config.MaxReputation = 200  -- Max XP for levels

-- Hotdog Spot Location (fixed)
Config.HotdogSpot = vector3(-342.65, 7151.67, 6.4)  -- Roxwood location

-- Stock System
Config.Stock = {
    ["exotic"] = {
        Current = 0,
        Max = { [1] = 15, [2] = 30, [3] = 45, [4] = 60 },  -- Max per level
        Label = "Exotic Dog",
        Price = {  -- Price range per level
            [1] = { min = 8, max = 12 },
            [2] = { min = 9, max = 13 },
            [3] = { min = 10, max = 14 },
            [4] = { min = 11, max = 15 },
        },
    },
    ["rare"] = {
        Current = 0,
        Max = { [1] = 15, [2] = 30, [3] = 45, [4] = 60 },
        Label = "Rare Dog",
        Price = {
            [1] = { min = 6, max = 9 },
            [2] = { min = 7, max = 10 },
            [3] = { min = 8, max = 11 },
            [4] = { min = 9, max = 12 },
        },
    },
    ["common"] = {
        Current = 0,
        Max = { [1] = 15, [2] = 30, [3] = 45, [4] = 60 },
        Label = "Common Dog",
        Price = {
            [1] = { min = 4, max = 6 },
            [2] = { min = 5, max = 7 },
            [3] = { min = 6, max = 9 },
            [4] = { min = 7, max = 9 },
        },
    },
}

-- Leveling System (Reputation -> Levels)
Config.Levels = {
    [1] = { minXP = 0, maxXP = 49 },
    [2] = { minXP = 50, maxXP = 99 },
    [3] = { minXP = 100, maxXP = 199 },
    [4] = { minXP = 200, maxXP = Config.MaxReputation },
}
