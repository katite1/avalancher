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

---@param template ItemTemplate
---@return Item
function Item:new(template)
    local t = setmetatable(PhysicsEntity:new(), self)
    ---@cast t Item

    t.name = template.name
    t.sprite = template.sprite
    t.template = template

    return t
end

function Item:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

---@param itemData {x: integer, y: integer, name: string}
function Item.deserialize(itemData)
    local item = Item:new(ItemTemplates[itemData.name])
    item.x = itemData.x
    item.y = itemData.y

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
    return Item.deserialize({
        x = 0,
        y = 0,
        name = type
    })
end

return Item
