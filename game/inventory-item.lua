---@class InventoryItem
---@field sprite love.Image
---@field name string
---@field quantity number
local InventoryItem = {}
InventoryItem.__index = InventoryItem

---@param template ItemTemplate
---@return InventoryItem
function InventoryItem:new(template)
    local t = setmetatable({}, self)
    t.name = template.name
    t.sprite = template.sprite
    t.quantity = 1
    return t
end

return InventoryItem
