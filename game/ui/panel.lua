local Element = require("game.ui.element")

---@class Panel
---@field spriteBatch love.SpriteBatch
---@field quads {topLeft: love.Quad, top: love.Quad, topRight: love.Quad, centerLeft: love.Quad, center: love.Quad, centerRight: love.Quad, bottomLeft: love.Quad, bottom: love.Quad, bottomRight: love.Quad}
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
    t.image = image
    t.offset = offset
    t.spriteBatch = love.graphics.newSpriteBatch(t.image)

    t.quads = {}
    t.quads.topLeft = love.graphics.newQuad(0, 0, t.offset, t.offset, t.image)
    t.quads.top = love.graphics.newQuad(t.offset, 0, t.offset, t.offset, t.image)
    t.quads.topRight = love.graphics.newQuad(t.offset * 2, 0, t.offset, t.offset, t.image)
    t.quads.centerLeft = love.graphics.newQuad(0, t.offset, t.offset, t.offset, t.image)
    t.quads.center = love.graphics.newQuad(t.offset, t.offset, t.offset, t.offset, t.image)
    t.quads.centerRight = love.graphics.newQuad(t.offset * 2, t.offset, t.offset, t.offset, t.image)
    t.quads.bottomLeft = love.graphics.newQuad(0, t.offset * 2, t.offset, t.offset, t.image)
    t.quads.bottom = love.graphics.newQuad(t.offset, t.offset * 2, t.offset, t.offset, t.image)
    t.quads.bottomRight = love.graphics.newQuad(t.offset * 2, t.offset * 2, t.offset, t.offset, t.image)

    return t
end

function Panel:draw(w, h)
    local middleW = w - self.offset * 2
    local middleH = h - self.offset * 2

    self.spriteBatch:clear()

    for i = 1, math.floor(middleW / self.offset), 1 do
        self.spriteBatch:add(self.quads.top, i * self.offset, 0)
        self.spriteBatch:add(self.quads.bottom, i * self.offset, middleH + self.offset)
    end

    self.spriteBatch:add(self.quads.center, self.offset, self.offset, 0, middleW / self.offset, middleH / self.offset)
    for i = 1, math.floor(middleH / self.offset), 1 do
        self.spriteBatch:add(self.quads.centerLeft, 0, i * self.offset)
        self.spriteBatch:add(self.quads.centerRight, middleW + self.offset, i * self.offset)
    end

    self.spriteBatch:add(self.quads.topLeft, 0, 0)
    self.spriteBatch:add(self.quads.topRight, middleW + self.offset, 0)
    self.spriteBatch:add(self.quads.bottomLeft, 0, middleH + self.offset)
    self.spriteBatch:add(self.quads.bottomRight, middleW + self.offset, middleH + self.offset)

    love.graphics.draw(self.spriteBatch)
end

return Panel
