---@class Tile
---@field x integer
---@field y integer
---@field width integer
---@field height integer
---@field value integer
---@field flipX boolean
---@field flipY boolean
local Tile = {}
Tile.__index = Tile

---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param value integer
---@param flipX true | nil
---@param flipY true | nil
---@return Tile
function Tile:new(x, y, w, h, value, flipX, flipY)
    local t = setmetatable({}, { __index = self })
    t.x = x
    t.y = y
    t.width = w
    t.height = h
    t.value = value
    t.flipX = flipX or false
    t.flipY = flipY or false
    return t
end

return Tile
