local FSM = require("core.fsm")
local Debug = require("core.debug")

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
---@field timers {[string]: Timer}
---@field fsm FSM
---@field applyLdtkData nil | fun(self, data)
---@field applyDeserializedData nil | fun(self, data)
---@field draw function | nil
---@field queuedDeletion boolean
---@field debug Debug
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
---@field timers {[string]: SerializedTimer}
---@field fsm SerializedFSM

---@param world World
function Entity:new(world)
    local t = setmetatable({}, self)
    t.x = 0
    t.y = 0
    t.w = 16
    t.h = 16
    t.bb = { x = t.x, y = t.y, w = t.w, h = t.h }
    t.world = world
    t.queuedDeletion = false
    t.timers = {}
    t.fsm = FSM:new(t)
    t.debug = Debug:new()
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
        timers = self:serializeTimers(),
        fsm = self.fsm:serialize(),
    }
end

---@param data SerializedEntity
function Entity:applyDeserializedData(data)
    self.x, self.y = data.x, data.y
    self.w, self.h = data.w, data.h
    self.bb = data.bb
    self.type = data.type
    self:deserializeTimers(data.timers)
    if self.fsm.registeredStates[data.fsm.currentState] then
        self.fsm:gotoState(self.fsm.registeredStates[data.fsm.currentState])
    end
end

---@return {[string]: SerializedTimer}
function Entity:serializeTimers()
    local timers = {}
    for name, timer in pairs(self.timers) do
        timers[name] = timer:serialize()
    end
    return timers
end

---@param timers SerializedTimer[]
function Entity:deserializeTimers(timers)
    for name, timer in pairs(timers) do
        assert(self.timers[name],
            string.format("Entity of type '%s' has no timer with name '%s'!!", self.type, name))
        self.timers[name]:applyDeserializedData(timer)
    end
end

function Entity:update()
    self.fsm:update()
    for _, timer in pairs(self.timers) do
        timer:update()
    end
end

---@return Rectangle
function Entity:getCollisionArea()
    ---@type Rectangle
    return {
        x = self.x + self.bb.x,
        y = self.y + self.bb.y,
        w = self.bb.w,
        h = self.bb.h
    }
end

---@param ... any
function Entity:d(...)
    self.debug:at(self.x, self.y)
    self.debug:write({ ... }, 3)
    self.debug:draw(1)
    self.debug:clear()
end

return Entity
