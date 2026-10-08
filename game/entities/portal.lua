local Entity = require("game.entities.base.entity")

---@class Portal : Entity
---@field sprite love.Image
---@field target string
local Portal = {}
Portal.__index = Portal
setmetatable(Portal, Entity)

---@param world World
---@return Portal
function Portal:new(world)
    local t = setmetatable(Entity:new(world), self)
    ---@cast t Portal
    t.bb = { x = 0, y = 8, w = 32, h = 8 }
    t.sprite = IMAGES.SPRITES.PORTAL
    t.target = ""
    return t
end

---@param ldtkEntity table
function Portal:applyLdtkData(ldtkEntity)
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "level" then
            self.target = field.__value
        end
    end
end

function Portal:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Portal
