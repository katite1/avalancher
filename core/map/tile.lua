---@class Tile
---@field x integer
---@field y integer
---@field width integer
---@field height integer
---@field value integer
local Tile = {}
Tile.__index = Tile

function Tile:new(x, y, w, h, value)
    local t = setmetatable({}, { __index = self })
    t.x = x
    t.y = y
    t.width = w
    t.height = h
    t.value = value
    return t
end

return Tile
