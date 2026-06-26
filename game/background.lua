---@class BackgroundData
---@field static {image: love.Image, quad?: love.Quad, repeatX: boolean, repeatY: boolean}[]
---@field parallax {image: love.Image, quad?: love.Quad, scaleX: number, scaleY: number}[]
---@field fillColor [number, number, number]
---@field opacity number

---@class Background
---@field backgrounds {[string]: BackgroundData}
---@field currentBackground BackgroundData
---@field backgroundData BackgroundData
---@field parallaxX integer
---@field parallaxY integer
local Background = {}
Background.__index = Background

function Background:new()
    local t = setmetatable({}, self)
    t.backgrounds = {}
    t.backgroundData = nil
    t.parallaxX = 0
    t.parallaxY = 0
    return t
end

---@param background string
function Background:set(background)
    self.backgroundData = self.backgrounds[background]
    for _, static in ipairs(self.backgroundData.static) do
        static.quad = love.graphics.newQuad(0, 0, SCREEN.WIDTH, SCREEN.HEIGHT, static.image)
    end
    for _, parallax in ipairs(self.backgroundData.parallax) do
        parallax.quad = love.graphics.newQuad(0, 0, SCREEN.WIDTH * 3, SCREEN.HEIGHT * 3, parallax.image)
    end
end

function Background:register(name, backgroundData)
    self.backgrounds[name] = backgroundData
end

function Background:draw()
    love.graphics.push("all")
    love.graphics.setColor(self.backgroundData.fillColor)
    love.graphics.rectangle("fill", 0, 0, SCREEN.WIDTH, SCREEN.HEIGHT)
    love.graphics.setColor(1, 1, 1, self.backgroundData.opacity)


    if self.backgroundData == nil then
        return
    end
    for _, staticBackground in ipairs(self.backgroundData.static) do
        love.graphics.draw(staticBackground.image, staticBackground.quad, 0, 0)
    end
    for _, parallaxBackground in ipairs(self.backgroundData.parallax) do
        love.graphics.draw(
            parallaxBackground.image, parallaxBackground.quad,
            math.fmod((self.parallaxX * parallaxBackground.scaleX - SCREEN.WIDTH), parallaxBackground.image:getWidth()),
            math.fmod((self.parallaxY * parallaxBackground.scaleY - SCREEN.HEIGHT), parallaxBackground.image:getHeight())
        )
    end
    love.graphics.pop()
end

return Background
