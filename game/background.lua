local BACKGROUND_INDEX = require("data.backgrounds.index")

---@class BackgroundStruct
---@field static {image: love.Image, quad?: love.Quad, repeatX: boolean, repeatY: boolean}[]
---@field parallax {image: love.Image, quad?: love.Quad, scaleX: number, scaleY: number}[]
---@field fillColor [number, number, number]
---@field opacity number

---@class Background
---@field backgroundData BackgroundStruct
local Background = {}
Background.__index = Background

function Background:new()
    local t = setmetatable({}, self)
    t.backgroundData = nil
    return t
end

---@param backgroundName string
function Background:set(backgroundName)
    local background = BACKGROUND_INDEX[backgroundName]
    assert(background, string.format("Background with name - '%s'", backgroundName))
    self.backgroundData = background
    for _, static in ipairs(self.backgroundData.static) do
        static.quad = love.graphics.newQuad(0, 0, SCREEN.WIDTH, SCREEN.HEIGHT, static.image)
    end
    for _, parallax in ipairs(self.backgroundData.parallax) do
        parallax.quad = love.graphics.newQuad(0, 0, SCREEN.WIDTH * 3, SCREEN.HEIGHT * 3, parallax.image)
    end
end

---@param parallaxX integer
---@param parallaxY integer
function Background:draw(parallaxX, parallaxY)
    if self.backgroundData == nil then
        return
    end

    love.graphics.push("all")
    love.graphics.setColor(self.backgroundData.fillColor)
    love.graphics.rectangle("fill", 0, 0, SCREEN.WIDTH, SCREEN.HEIGHT)
    love.graphics.setColor(1, 1, 1, self.backgroundData.opacity)
    for _, staticBackground in ipairs(self.backgroundData.static) do
        love.graphics.draw(staticBackground.image, staticBackground.quad, 0, 0)
    end
    for _, parallaxBackground in ipairs(self.backgroundData.parallax) do
        love.graphics.draw(
            parallaxBackground.image, parallaxBackground.quad,
            math.fmod((parallaxX * parallaxBackground.scaleX - SCREEN.WIDTH), parallaxBackground.image:getWidth()),
            math.fmod((parallaxY * parallaxBackground.scaleY - SCREEN.HEIGHT), parallaxBackground.image:getHeight())
        )
    end
    love.graphics.pop()
end

return Background
