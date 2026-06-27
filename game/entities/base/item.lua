local PhysicsEntity = require("game.entities.base.physics-entity")
local ItemTemplates = require("data.items.item-templates")

---@class ItemTemplate
---@field sprite love.Image
---@field name string

---@class Item: PhysicsEntity
---@field sprite love.Image
---@field name string
local Item = {}
Item.__index = Item
setmetatable(Item, PhysicsEntity)

---@param template ItemTemplate
---@return Item
function Item:new(template)
    local t = setmetatable(PhysicsEntity:new(), self)
    ---@cast t Item

    t.name = template.name
    t.sprite = template.sprite

    return t
end

function Item:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Item.deserializeLdtk(ldtkEntity)
    local type = nil
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "type" then
            type = string.lower(field.__value)
        end
    end
    return Item:new(ItemTemplates[type])
end

return Item
