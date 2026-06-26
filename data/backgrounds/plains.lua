---@type BackgroundData
local background = {
    fillColor = { 0.3, 0.3, 0.5 },
    opacity = 0.7,
    -- fillColor = { 1, 1, 1 },
    -- opacity = 1,
    static = {
        {
            image = BACKGROUNDS.PLAINS.BASE,
            repeatX = true,
            repeatY = true
        }
    },
    parallax = {
        {
            image = BACKGROUNDS.PLAINS.MOUNTAINS,
            scaleX = 0.05,
            scaleY = 0
        },
        {
            image = BACKGROUNDS.PLAINS.GRASS,
            scaleX = 0.1,
            scaleY = 0
        }
    }
}
return background
