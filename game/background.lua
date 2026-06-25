---@class BackgroundData
---@field static {image: love.Image, quad?: love.Quad, repeatX: boolean, repeatY: boolean}[]
---@field parallax {image: love.Image, quad?: love.Quad, scaleX: number, scaleY: number}[]


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
        parallax.quad = love.graphics.newQuad(0, 0, SCREEN.WIDTH, SCREEN.HEIGHT, parallax.image)
    end
end

function Background:register(name, backgroundData)
    self.backgrounds[name] = backgroundData
end

function Background:draw()
    if self.backgroundData == nil then
        return
    end
    for _, staticBackground in ipairs(self.backgroundData.static) do
        love.graphics.draw(staticBackground.image, staticBackground.quad, 0, 0)
    end
    for _, parallaxBackground in ipairs(self.backgroundData.parallax) do
        love.graphics.draw(parallaxBackground.image, parallaxBackground.quad, self.parallaxX * parallaxBackground.scaleX,
            self.parallaxY * parallaxBackground.scaleY)
    end
end

return Background
