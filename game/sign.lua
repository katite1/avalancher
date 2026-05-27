local Entity = require("game.entity")

---@class Sign: Entity
---@field sprite love.Image
local Sign = {}
Sign.__index = Sign
setmetatable(Sign, Entity)

---@return Sign
function Sign:new()
    local t = setmetatable(Entity:new(), self)
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    t.sprite = SPRITES.SIGN
    ---@cast t Sign
    return t
end

function Sign:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
    love.graphics.rectangle("line", self.x + self.bb.x, self.y + self.bb.y, self.bb.w, self.bb.h)
end

return Sign
