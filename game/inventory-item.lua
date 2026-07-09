local itemTemplates = require("data.items.item-templates")

---@class InventoryItem
---@field sprite love.Image
---@field name string
---@field quantity number
local InventoryItem = {}
InventoryItem.__index = InventoryItem

---@class SerializedInventoryItem
---@field name string
---@field quantity integer

---@param name string
---@param quantity integer | nil
---@return InventoryItem
function InventoryItem:new(name, quantity)
    local t = setmetatable({}, self)
    t.name = name
    t.sprite = itemTemplates[name].sprite
    t.quantity = quantity or 1
    return t
end

---@return SerializedInventoryItem
function InventoryItem:serialize()
    return {
        name = self.name,
        quantity = self.quantity
    }
end

---@param serializedInventoryItem SerializedInventoryItem
function InventoryItem:deserialize(serializedInventoryItem)
    local item = InventoryItem:new(serializedInventoryItem.name)
    item.quantity = serializedInventoryItem.quantity
    item.sprite = itemTemplates[serializedInventoryItem.name].sprite
    return item
end

return InventoryItem
