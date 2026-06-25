---@class EntityManager
---@field world World
---@field entities Entity[]
local EntityManager = {}
EntityManager.__index = EntityManager

---@param world World
---@return EntityManager
function EntityManager:new(world)
    local t = setmetatable({}, { __index = self })
    t.world = world
    t.entities = {}
    return t
end

---@generic T : Entity
---@param entity T
---@param ldtkEntity table | nil
---@return T
function EntityManager:makeFromLdtk(entity, ldtkEntity)
    ---@cast entity Entity
    local e = nil
    if ldtkEntity and entity.deserializeLdtk then
        e = entity.deserializeLdtk(ldtkEntity)
    else
        e = entity:new()
    end

    e.world = self.world
    table.insert(self.entities, e)

    return e
end

function EntityManager:update()
    for _, entity in pairs(self.entities) do
        entity:update()
    end
end

function EntityManager:draw()
    for _, entity in pairs(self.entities) do
        if entity.draw then entity:draw() end
    end
end

---@generic T
---@param class T
---@return T[] | false
function EntityManager:getAll(class)
    local entities = {}
    for _, entity in pairs(self.entities) do
        if O.isInstance(entity, class) then
            table.insert(entities, entity)
        end
    end
    return #entities ~= 0 and entities
end

---@generic T
---@param class T
---@return T | nil
function EntityManager:getFirst(class)
    for _, entity in pairs(self.entities) do
        if O.isInstance(entity, class) then
            return entity
        end
    end
    return nil
end

---@generic T
---@param x integer
---@param y integer
---@param class T
---@return T | nil
function EntityManager:getClosest(x, y, class)
    local closestEntity = nil
    local closestDistance = 9999999999 -- i don't know if lua has an infinite value
    for _, entity in pairs(self.entities) do
        if O.isInstance(entity, class) then
            local distance = M.distance(x, y, entity.x, entity.y)
            if distance < closestDistance then
                closestDistance = distance
                closestEntity = entity
            end
        end
    end
    return closestEntity
end

function EntityManager:clearAll()
    self.entities = {}
end

return EntityManager
