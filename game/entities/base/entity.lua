---@alias BoundingBox {x: number, y: number, w: number, h: number}
---@alias SerializedBoundingBox BoundingBox

---@class Entity
---@field uid string
---@field world World
---@field x number
---@field y number
---@field w number
---@field h number
---@field type EntityType
---@field bb BoundingBox
---@field update function
---@field dialogueReference string | nil
---@field deserializeLdtk nil | fun(data): Entity
---@field draw function | nil
---@field queuedDeletion boolean
local Entity = {}
Entity.__index = Entity

---@class SerializedEntity
---@field uid string
---@field type EntityType
---@field x number
---@field y number
---@field w number
---@field h number
---@field bb SerializedBoundingBox
---@field dialogueReference string | nil

function Entity:new()
    local t = setmetatable({}, self)
    t.x = 0
    t.y = 0
    t.w = 16
    t.h = 16
    t.bb = { x = t.x, y = t.y, w = t.w, h = t.h }
    t.world = nil
    t.queuedDeletion = false
    return t
end

---@return SerializedEntity
function Entity:serialize()
    ---@type SerializedEntity
    return {
        uid = self.uid,
        type = self.type,
        x = self.x,
        y = self.y,
        w = self.w,
        h = self.h,
        bb = self.bb,
        dialogueReference = self.dialogueReference,
    }
end

---@param data SerializedEntity
---@return Entity
function Entity.deserialize(data)
    local entity = Entity:new()
    entity.x, entity.y = data.x, data.y
    entity.w, entity.h = data.w, data.h
    entity.bb = data.bb
    entity.dialogueReference = data.dialogueReference
    entity.type = data.type
    return entity
end

function Entity:update()
end

return Entity
