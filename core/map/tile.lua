---@class Tile
---@field x integer
---@field y integer
---@field width integer
---@field height integer
---@field value integer
---@field offsetX integer
---@field offsetY integer
---@field flipX boolean
---@field flipY boolean
local Tile = {}
Tile.__index = Tile

---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param value integer
---@param offsetX integer | nil
---@param offsetY integer | nil
---@return Tile
function Tile:new(x, y, w, h, value, offsetX, offsetY)
    local t = setmetatable({}, { __index = self })
    t.x = x
    t.y = y
    t.width = w
    t.height = h
    t.value = value
    t.offsetX = offsetX or 0
    t.offsetY = offsetY or 0
    return t
end

return Tile
