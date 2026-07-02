local itemTemplates = require("data.items.item-templates")

---@class InventoryItem
---@field sprite love.Image
---@field name string
---@field quantity number
local InventoryItem = {}
InventoryItem.__index = InventoryItem

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

function InventoryItem:serialize()
    return {
        name = self.name,
        quantity = self.quantity
    }
end

---@param itemData table
function InventoryItem:deserialize(itemData)
    local item = InventoryItem:new(itemData.name)
    item.quantity = itemData.quantity
    item.sprite = itemTemplates[itemData.name].sprite
    return item
end

return InventoryItem
