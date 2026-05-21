---@class EntityManager
---@field entities Entity[]
local EntityManager = {}
EntityManager.__index = EntityManager

function EntityManager:new()
    local t = setmetatable({}, { __index = self })
    t.entities = {}
    return t
end

---@generic T : Entity
---@param entity T
---@return T
function EntityManager:make(entity)
    ---@cast entity Entity
    local e = entity:new()
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

return EntityManager
