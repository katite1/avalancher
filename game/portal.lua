local Entity = require("game.entity")

---@class Portal : Entity
---@field sprite love.Image
---@field target string
local Portal = {}
Portal.__index = Portal
setmetatable(Portal, Entity)

---@return Portal
function Portal:new()
    local t = setmetatable(Entity:new(), self)
    ---@cast t Portal
    t.bb = { x = 0, y = 8, w = 32, h = 8 }
    t.sprite = SPRITES.PORTAL
    t.target = ""
    return t
end

function Portal:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Portal
