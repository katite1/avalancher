local PhysicsEntity = require("game.entities.base.physics-entity")
local FSM = require("core.fsm")
local FSMState = require("core.fsm-state")

---@class Mushroom: PhysicsEntity
---@field fsm FSM
---@field patrolStart {x: number, y: number}
---@field patrolEnd {x: number, y: number}
---@field sprite love.Image
---@field patrolState FSMState
local Mushroom = {}
Mushroom.__index = Mushroom
setmetatable(Mushroom, PhysicsEntity)


---@class SerializedMushroom : SerializedPhysicsEntity

---@return Mushroom
function Mushroom:new()
    local t = setmetatable(PhysicsEntity:new(), self)
    ---@cast t Mushroom
    t.type = "mushroom"
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    t.sprite = SPRITES.MUSHROOM
    t.patrolStart = { x = 0, y = 0 }
    t.patrolEnd = { x = 0, y = 0 }
    t.fsm = FSM:new()
    t.patrolState = t:patrolStateInit()
    t.fsm:gotoState(t.patrolState)
    return t
end

function Mushroom.deserialize(data)
    local mushroom = PhysicsEntity.deserialize(data)
    setmetatable(mushroom, Mushroom)
    ---@cast mushroom Mushroom
    mushroom.type = "mushroom"
    mushroom.sprite = SPRITES.MUSHROOM
    return mushroom
end

function Mushroom.deserializeLdtk(ldtkEntity)
    local mushroom = Mushroom:new()
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "patrolStart" then
            mushroom.patrolStart = { x = field.__value.cx, y = field.__value.cy }
        end
        if field.__identifier == "patrolEnd" then
            mushroom.patrolEnd = { x = field.__value.cx, y = field.__value.cy }
        end
    end
    return mushroom
end

function Mushroom:patrolStateInit()
    local state = FSMState:new()
    state.update = self.patrolStateUpdate
    return state
end

function Mushroom:patrolStateUpdate()
    if self.x > self.patrolStart.x then
        self:walkLeft()
    end
    if self.x < self.patrolStart.x then
        self:walkRight()
    end
end

function Mushroom:update()
    PhysicsEntity.update(self)
    self.fsm:update()
end

function Mushroom:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Mushroom
