local PhysicsEntity = require("game.entities.base.physics-entity")
local ItemTemplates = require("data.items.item-templates")

---@class ItemTemplate
---@field sprite love.Image
---@field name string

---@class Item: PhysicsEntity
---@field sprite love.Image
---@field name string
---@field template ItemTemplate
local Item = {}
Item.__index = Item
setmetatable(Item, PhysicsEntity)

---@class SerializedItem : SerializedPhysicsEntity
---@field name string

---@param template ItemTemplate
---@return Item
function Item:new(template)
    local t = setmetatable(PhysicsEntity:new(), self)
    ---@cast t Item

    t.type = "item"
    t.name = template.name
    t.sprite = template.sprite
    t.template = template

    return t
end

---@return SerializedItem
function Item:serialize()
    local serializedItem = PhysicsEntity.serialize(self)
    ---@cast serializedItem SerializedItem
    serializedItem.name = self.name
    return serializedItem
end

---@param serializedItem SerializedItem
---@return Item
function Item.deserialize(serializedItem)
    local item = PhysicsEntity.deserialize(serializedItem)
    setmetatable(item, Item)
    ---@cast item Item
    local template = ItemTemplates[serializedItem.name]
    item.name = template.name
    item.sprite = template.sprite
    item.template = template

    return item
end

function Item.deserializeLdtk(ldtkEntity)
    local type = nil
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "type" then
            type = string.lower(field.__value)
        end
    end
    if type == nil then
        error("No item type specified for item in LDtk!")
    end
    return Item:new(ItemTemplates[type])
end

function Item:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Item
