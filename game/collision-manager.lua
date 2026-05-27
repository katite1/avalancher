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

---@param entity1 Entity
---@param entity2 Entity
---@return boolean
function CollisionManager:areOverlapping(entity1, entity2)
    return self:AABB(
        entity1.x + entity1.bb.x,
        entity1.y + entity1.bb.y,
        entity1.bb.w,
        entity1.bb.h,
        entity2.x + entity2.bb.x,
        entity2.y + entity2.bb.y,
        entity2.bb.w,
        entity2.bb.h
    )
end

---@param x1 integer
---@param y1 integer
---@param w1 integer
---@param h1 integer
---@param x2 integer
---@param y2 integer
---@param w2 integer
---@param h2 integer
---@return boolean
function CollisionManager:AABB(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end

return CollisionManager
