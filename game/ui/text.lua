local Element = require("game.ui.element")

---@class Text
---@field content string
local Text = {}
Text.__index = Text
setmetatable(Text, Element)

function Text:new()
    local t = setmetatable(Element:new(), self)
    ---@cast t Text
    return t
end

function Text:draw(x, y, w, h)
    love.graphics.printf(
        self.content,
        8, 8, SCREEN.WIDTH - 16
    )
end

return Text
