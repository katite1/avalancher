---@class EntityManager
---@field world World
---@field entities Entity[]
local EntityManager = {}
EntityManager.__index = EntityManager

---@class SerializedEntityManager
---@field entities SerializedEntity[]

---@param world World
---@return EntityManager
function EntityManager:new(world)
    local t = setmetatable({}, { __index = self })
    t.world = world
    t.entities = {}
    return t
end

---@return SerializedEntityManager
function EntityManager:serialize()
    local serializedEntities = {}
    for _, entity in pairs(self.entities) do
        table.insert(serializedEntities, entity:serialize())
    end
    return { entities = serializedEntities }
end

---@param data SerializedEntityManager
---@param world World
---@return EntityManager
function EntityManager.deserialize(data, world)
    local entityManager = EntityManager:new(world)
    for _, entity in ipairs(data.entities) do
        if ENTITY_TYPE[entity.type] then
            entityManager:add(ENTITY_TYPE[entity.type].deserialize(entity, world))
        end
    end
    return entityManager
end

---@generic T : Entity
---@param entity T
---@param ldtkEntity table | nil
---@return T
function EntityManager:makeFromLdtk(entity, ldtkEntity)
    ---@cast entity Entity
    local e = nil
    if ldtkEntity and entity.deserializeLdtk then
        e = entity.deserializeLdtk(ldtkEntity, self.world)
    else
        e = entity:new(self.world)
    end

    e.world = self.world
    table.insert(self.entities, e)

    return e
end

---@param entity Entity
function EntityManager:add(entity)
    entity.world = self.world
    table.insert(self.entities, entity)
end

function EntityManager:update()
    for _, entity in pairs(self.entities) do
        entity:update()
    end

    local entityCount = #self.entities
    for i = entityCount, 1, -1 do
        if self.entities[i].queuedDeletion then
            table.remove(self.entities, i)
        end
    end
end

function EntityManager:draw()
    for _, entity in pairs(self.entities) do
        if entity.draw then entity:draw() end
    end
end

function EntityManager:drawCollisionAreas()
    love.graphics.push("all")
    love.graphics.setColor(1, 0, 0, 1)
    for _, entity in pairs(self.entities) do
        local rectangle = entity:getCollisionArea()
        love.graphics.rectangle("line", rectangle.x, rectangle.y, rectangle.w, rectangle.h)
    end
    love.graphics.pop()
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

---@param entity Entity
---@return Entity[]
function EntityManager:getOverlapping(entity)
    local entityCollisionArea = entity:getCollisionArea()
    local entities = {}
    for _, otherEntity in pairs(self.entities) do
        if entity ~= otherEntity then
            if self.world.collisionManager:AABB(
                    entityCollisionArea,
                    otherEntity:getCollisionArea()
                ) then
                table.insert(entities, otherEntity)
            end
        end
    end
    return entities
end

---@param entity Entity
function EntityManager:delete(entity)
    entity.queuedDeletion = true
end

function EntityManager:clearAll()
    self.entities = {}
end

return EntityManager
