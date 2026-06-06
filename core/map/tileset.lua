---@class Tileset
---@field firstID integer
---@field image love.Image
local Tileset = {}
Tileset.__index = Tileset

---@param firstID integer
---@param image love.Image
---@return Tileset
function Tileset:new(firstID, image)
    local t = setmetatable({}, self)
    t.firstID = firstID
    t.image = image
    return t
end

return Tileset
