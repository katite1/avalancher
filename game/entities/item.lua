local PhysicsEntity = require("game.entities.base.physics-entity")
local Items = require("data.items.items")

---@class ItemData
---@field sprite love.Image
---@field name string

---@class Item: PhysicsEntity
---@field sprite love.Image
---@field name string
local Item = {}
Item.__index = Item
setmetatable(Item, PhysicsEntity)

---@param data ItemData
---@return Item
function Item:new(data)
    local t = setmetatable(PhysicsEntity:new(), self)
    ---@cast t Item

    t.name = data.name
    t.sprite = data.sprite

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
    return Item:new(Items[type])
end

return Item
