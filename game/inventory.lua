local Panel         = require("game.ui.panel")
local InventoryItem = require("game.inventory-item")

---@class Inventory
---@field items InventoryItem[]
---@field equipped string
---@field inventoryPanel Panel
local Inventory     = {}
Inventory.__index   = Inventory

function Inventory:new()
    local t = setmetatable({}, self)
    t.inventoryPanel = Panel:new(SPRITES.PANEL, 8)
    t.items = {}
    return t
end

function Inventory:draw()
    self.inventoryPanel:draw(240, 176)
    for i, item in ipairs(self.items) do
        local x = 32 + (i * 32 - 32) % 128
        local y = 32 + math.floor(i / 4 - 0.01) * 32
        love.graphics.draw(item.sprite, x, y)
        love.graphics.print(item.quantity, x + 16, y + 16)
    end
end

-- ---@param template ItemTemplate
-- function Inventory:add(template)
--     local existingItem = self:get(template.name)
--     if existingItem then
--         existingItem.quantity = existingItem.quantity + 1
--         return
--     end
--     table.insert(self.items, InventoryItem:fromTemplate(template))
-- end
---@param itemByName string
function Inventory:add(itemByName, quantity)
    local existingItem = self:get(itemByName)
    if existingItem then
        existingItem.quantity = existingItem.quantity + 1
        return
    end
    table.insert(self.items, InventoryItem:new(itemByName, quantity))
end

---@param itemByName string
---@param quantity integer | nil
function Inventory:remove(itemByName, quantity)
    quantity = quantity or 1
    local item = self:get(itemByName)
    if not item then
        error("Item " .. item .. " does not exist")
    end
    if item.quantity >= 1 then
        item.quantity = item.quantity - quantity
    end

    if item.quantity > 0 then
        return
    end

    local itemCount = #self.items
    for i = itemCount, 1, -1 do
        if self.items[i] == item then
            table.remove(self.items, i)
        end
    end
end

---@param itemByName string
---@return InventoryItem | nil
function Inventory:get(itemByName)
    for _, item in ipairs(self.items) do
        if item.name == itemByName then
            return item
        end
    end
    return nil
end

---@return table
function Inventory:serialize()
    local inventory = {}
    for _, item in ipairs(self.items) do
        -- table.insert(inventory, { name = item.name, quantity = item.quantity })
        table.insert(inventory, item:serialize())
    end
    return inventory
end

---@param inventoryData table
---@return Inventory
function Inventory.deserialize(inventoryData)
    local inventory = Inventory:new()
    for _, itemData in ipairs(inventoryData) do
        inventory:add(itemData.name, itemData.quantity)
    end
    return inventory
end

return Inventory
