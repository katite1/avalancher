---@class Tile
---@field x integer
---@field y integer
---@field value integer
local Tile = {}
function Tile:new(x, y, value)
    local t = setmetatable({}, { __index = self })
    t.x = x
    t.y = y
    t.value = value
    return t
end

return Tile
