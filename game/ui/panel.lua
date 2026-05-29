local Element = require("game.ui.element")

---@class Panel
---@field spriteBatch love.SpriteBatch
---@field image love.Image
---@field offset integer
---@field x integer
---@field y integer
---@field w integer
---@field h integer
local Panel = {}
Panel.__index = Panel
setmetatable(Panel, Element)

---@param image love.Image
---@return Panel
function Panel:new(image, offset)
    local t = setmetatable(Element:new(), self)
    ---@cast t Panel
    self.image = image
    self.offset = offset
    self.spriteBatch = love.graphics.newSpriteBatch(self.image)
    return t
end

function Panel:draw(w, h)
    local middleW = w - self.offset * 2
    local middleH = h - self.offset * 2

    local topLeft = love.graphics.newQuad(0, 0, self.offset, self.offset, self.image)
    local top = love.graphics.newQuad(self.offset, 0, self.offset, self.offset, self.image)
    local topRight = love.graphics.newQuad(self.offset * 2, 0, self.offset, self.offset, self.image)
    local centerLeft = love.graphics.newQuad(0, self.offset, self.offset, self.offset, self.image)
    local center = love.graphics.newQuad(self.offset, self.offset, self.offset, self.offset, self.image)
    local centerRight = love.graphics.newQuad(self.offset * 2, self.offset, self.offset, self.offset, self.image)
    local bottomLeft = love.graphics.newQuad(0, self.offset * 2, self.offset, self.offset, self.image)
    local bottom = love.graphics.newQuad(self.offset, self.offset * 2, self.offset, self.offset, self.image)
    local bottomRight = love.graphics.newQuad(self.offset * 2, self.offset * 2, self.offset, self.offset, self.image)
    love.graphics.draw(self.image, topLeft, 0, 0)
    self.spriteBatch:clear()

    for i = 1, math.floor(middleW / self.offset), 1 do
        self.spriteBatch:add(top, i * self.offset, 0)
        self.spriteBatch:add(bottom, i * self.offset, middleH + self.offset)
    end

    self.spriteBatch:add(center, self.offset, self.offset, 0, middleW / self.offset, middleH / self.offset)
    for i = 1, math.floor(middleH / self.offset), 1 do
        self.spriteBatch:add(centerLeft, 0, i * self.offset)
        self.spriteBatch:add(centerRight, middleW + self.offset, i * self.offset)
    end

    self.spriteBatch:add(topLeft, 0, 0)
    self.spriteBatch:add(topRight, middleW + self.offset, 0)
    self.spriteBatch:add(bottomLeft, 0, middleH + self.offset)
    self.spriteBatch:add(bottomRight, middleW + self.offset, middleH + self.offset)

    love.graphics.draw(self.spriteBatch)
end

return Panel
