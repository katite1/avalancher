local Entity = require("game.entities.base.entity")

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

function Portal.deserializeLdtk(ldtkEntity)
    local portal = Portal:new()
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "level" then
            portal.target = field.__value
        end
    end
    return portal
end

function Portal:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Portal
