---@class CollisionManager
---@field world World
local CollisionManager = {}

---@param world World
---@return CollisionManager
function CollisionManager:new(world)
    local t = setmetatable({}, { __index = self })
    t.world = world
    return t
end

---@param entity Entity
---@return boolean
function CollisionManager:getCollisions(entity)
    -- We subtract 1 because otherwise when we do the tile check we check from 0-16
    -- which would end up as 17 pixels and would include 2 tiles on an object that has w at 16
    local tiles = self.world.tileMap:getTilesInRectangle(
        entity.x + entity.bb.x,
        entity.y + entity.bb.y,
        entity.bb.w,
        entity.bb.h
    )
    return #tiles ~= 0
end

return CollisionManager
