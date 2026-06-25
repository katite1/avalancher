-- return {
--     static = {
--         {
--             source = "grass-background-base.png",
--             repeatX = true,
--             repeatY = true
--         }
--     },
--     parallax = {
--         {
--             source = "grass-background-parallax.png",
--             scaleX = 0.25,
--             scaleY = 0.25
--         }
--     }
-- } --[[@as BackgroundData]]


---@type BackgroundData
local background = {
    static = {
        {
            image = BACKGROUNDS.PLAINS.BASE,
            repeatX = true,
            repeatY = true
        }
    },
    parallax = {
        {
            image = BACKGROUNDS.PLAINS.PARALLAX,
            scaleX = 0.25,
            scaleY = 0.25
        }
    }
}
return background
