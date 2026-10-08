local PhysicsEntity = require("game.entities.base.physics-entity")
local ITEM_INDEX = require("data.items.index")

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

---@param world World
---@param template ItemTemplate
---@return Item
function Item:new(world, template)
    local t = setmetatable(PhysicsEntity:new(world), self)
    ---@cast t Item
    t.type = "item"
    if template == nil then
        template = ITEM_INDEX["carrot"] -- TODO: add proper placeholder item for no template
    end

    t:applyTemplate(template)

    return t
end

---@param template table
function Item:applyTemplate(template)
    self.name = template.name
    self.sprite = template.sprite
    self.template = template
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
function Item:applyDeserializedData(serializedItem)
    PhysicsEntity.applyDeserializedData(self, serializedItem)
    local template = ITEM_INDEX[serializedItem.name]
    self:applyTemplate(template)
end

---@param ldtkEntity table
function Item:applyLdtkData(ldtkEntity)
    local template = nil
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "type" then
            template = string.lower(field.__value)
        end
    end
    if template == nil then
        error("No item type specified for item in LDtk!")
    end
    self:applyTemplate(ITEM_INDEX[template])
end

function Item:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Item
