local Timer = require("core.timer")

---@class Sprite
---@field image love.Image
---@field frameWidth integer
---@field frameHeight integer
---@field animationSpeed integer
---@field timer Timer
---@field currentFrame integer
---@field totalFrames integer
---@field quads love.Quad[]
---@field flipX boolean
local Sprite = {}
Sprite.__index = Sprite

---@param image love.Image
---@param frameWidth integer
---@param frameHeight integer
---@param animationSpeed integer
---@return Sprite
function Sprite:new(image, frameWidth, frameHeight, animationSpeed)
    ---@type Sprite
    local t = setmetatable({}, self)
    t.image = image
    t.frameWidth = frameWidth
    t.frameHeight = frameHeight
    t.animationSpeed = animationSpeed
    t.quads = t:makeQuads()
    t.currentFrame = 1
    t.totalFrames = #t.quads
    t.flipX = false
    if animationSpeed == 0 then
        t.timer = nil
        return t
    end
    t.timer = Timer:new(animationSpeed, function()
        t.currentFrame = t.currentFrame + 1
        if t.currentFrame > t.totalFrames then
            t.currentFrame = 1
        end
    end, true)

    return t
end

---@return love.Quad[]
function Sprite:makeQuads()
    local imageWidth, imageHeight = self.image:getDimensions()
    local quads = {}
    for x = 1, imageWidth / self.frameWidth, 1 do
        table.insert(quads,
            love.graphics.newQuad(x * self.frameWidth - self.frameWidth, 0, self.frameWidth, self.frameHeight, self
                .image))
    end
    return quads
end

function Sprite:update()
    if self.animationSpeed == 0 then
        return
    end
    self.timer:update()
end

function Sprite:draw(x, y)
    local scaleX = self.flipX and -1 or 1
    love.graphics.draw(self.image, self.quads[self.currentFrame], x + self.frameWidth / 2, y + self.frameHeight / 2, 0,
        scaleX, 1, self.frameWidth / 2,
        self.frameHeight / 2)
end

return Sprite
