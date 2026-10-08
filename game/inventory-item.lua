local ITEM_INDEX = require("data.items.index")

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
    t.sprite = ITEM_INDEX[name].sprite
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
    item.sprite = ITEM_INDEX[serializedInventoryItem.name].sprite
    return item
end

return InventoryItem
