---@type BackgroundStruct
local background = {
    fillColor = { 0.3, 0.3, 0.5 },
    opacity = 0.7,
    -- fillColor = { 1, 1, 1 },
    -- opacity = 1,
    static = {
        {
            image = IMAGES.BACKGROUNDS.PLAINS.BASE,
            repeatX = true,
            repeatY = true
        }
    },
    parallax = {
        {
            image = IMAGES.BACKGROUNDS.PLAINS.MOUNTAINS,
            scaleX = 0.05,
            scaleY = 0
        },
        {
            image = IMAGES.BACKGROUNDS.PLAINS.GRASS,
            scaleX = 0.1,
            scaleY = 0
        }
    }
}
return background
