local PhysicsEntity = require("game.entities.base.physics-entity")
local FSM = require("core.fsm")
local FSMState = require("core.fsm-state")
local PatrolState = require("game.entities.mushroom.states.patrol")
local PatrolWaitState = require("game.entities.mushroom.states.patrol-wait")
local StompedState = require("game.entities.mushroom.states.stomped")
local Sprite = require("game.sprite")

---@class Mushroom: PhysicsEntity
---@field fsm FSM
---@field target {x: number, y: number}
---@field patrolStart {x: number, y: number}
---@field patrolEnd {x: number, y: number}
---@field sprite Sprite
---@field patrolState FSMState
---@field patrolWaitState FSMState
---@field stompedState FSMState
---@field patrolWaitTimer Timer
local Mushroom = {}
Mushroom.__index = Mushroom
setmetatable(Mushroom, PhysicsEntity)


---@class SerializedMushroom : SerializedPhysicsEntity

---@param world World
---@return Mushroom
function Mushroom:new(world)
    local t = setmetatable(PhysicsEntity:new(world), self)
    ---@cast t Mushroom
    t.type = "mushroom"
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    t.sprite = Sprite:new(SPRITES.MUSHROOM_WALK, 16, 16, 6)
    t.patrolStart = { x = 0, y = 0 }
    t.patrolEnd = { x = 0, y = 0 }
    t.walkSpeed = 0.35
    t.fsm = FSM:new(t)
    t.patrolState = FSMState:new(t)
    -- setmetatable(t.patrolState, { __index = Mushroom.patrolState })
    -- t.patrolWaitState = FSMState:new(t)
    -- setmetatable(t.patrolWaitState, { __index = Mushroom.patrolWaitState })
    -- t.stompedState = FSMState:new(t)
    -- setmetatable(t.stompedState, { __index = Mushroom.stompedState })
    t.patrolState = FSMState:new(t)
    setmetatable(t.patrolState, { __index = PatrolState })
    t.patrolWaitState = FSMState:new(t)
    setmetatable(t.patrolWaitState, { __index = PatrolWaitState })
    t.stompedState = FSMState:new(t)
    setmetatable(t.stompedState, { __index = StompedState })
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

function Mushroom.deserializeLdtk(ldtkEntity, world)
    local mushroom = Mushroom:new(world)
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "patrolStart" then
            mushroom.patrolStart = { x = field.__value.cx * 16, y = field.__value.cy * 16 }
        end
        if field.__identifier == "patrolEnd" then
            mushroom.patrolEnd = { x = field.__value.cx * 16, y = field.__value.cy * 16 }
        end
    end
    mushroom.target = mushroom.patrolStart
    return mushroom
end

function Mushroom:stomp()
    if self.fsm.currentState ~= self.stompedState then
        self.fsm:gotoState(self.stompedState)
        return true
    end
    return false
end

function Mushroom:update()
    PhysicsEntity.update(self)
    self.fsm:update()
    if self.facingLeft then
        self.sprite.flipX = true
    else
        self.sprite.flipX = false
    end
    self.sprite:update()
end

function Mushroom:draw()
    self.sprite:draw(self.x, self.y)
end

return Mushroom
