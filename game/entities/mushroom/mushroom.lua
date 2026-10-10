local PhysicsEntity = require("game.entities.base.physics-entity")
local FSM = require("core.fsm")
local FSMState = require("core.fsm-state")
local PatrolState = require("game.entities.mushroom.states.patrol")
local PatrolWaitState = require("game.entities.mushroom.states.patrol-wait")
local StompedState = require("game.entities.mushroom.states.stomped")
local Sprite = require("game.sprite")
local Timer = require("core.timer")

---@class Mushroom: PhysicsEntity
---@field fsm FSM
---@field target {x: number, y: number}
---@field patrolStart {x: number, y: number}
---@field patrolEnd {x: number, y: number}
---@field sprite Sprite
---@field patrolSprite Sprite
---@field stompedSprite Sprite
---@field idleSprite Sprite
---@field patrolState FSMState
---@field patrolWaitState FSMState
---@field stompedState FSMState
---@field patrolWaitTimer Timer
local Mushroom = {}
Mushroom.__index = Mushroom
Mushroom.patrolSprite = Sprite:new(IMAGES.SPRITES.MUSHROOM_WALK, 16, 16, 6)
Mushroom.stompedSprite = Sprite:new(IMAGES.SPRITES.MUSHROOM_STOMPED, 16, 16, 0)
Mushroom.idleSprite = Sprite:new(IMAGES.SPRITES.MUSHROOM_IDLE, 16, 16, 18)

setmetatable(Mushroom, PhysicsEntity)

---@class SerializedMushroom : SerializedPhysicsEntity
---@field patrolStart {x: number, y: number}
---@field patrolEnd {x: number, y: number}
---@field target {x: number, y: number}

---@param world World
---@return Mushroom
function Mushroom:new(world)
    local t = setmetatable(PhysicsEntity:new(world), self)
    ---@cast t Mushroom
    t.type = "mushroom"
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    t.sprite = t.patrolSprite
    t.patrolStart = { x = 0, y = 0 }
    t.patrolEnd = { x = 0, y = 0 }
    t.walkSpeed = 0.35
    t.timers.jump = Timer:new(50, function()
        t:jump()
    end)
    t.timers.wait = Timer:new(100, function()
        t.fsm:gotoState(t.patrolState)
    end)
    t.timers.unstomp = Timer:new(120, function()
    end)

    t.patrolState = PatrolState
    t.patrolWaitState = PatrolWaitState
    t.stompedState = StompedState
    t.fsm:registerState(t.patrolState, "patrol")
    t.fsm:registerState(t.patrolWaitState, "wait")
    t.fsm:registerState(t.stompedState, "stomped")
    t.fsm:gotoState(t.patrolState)
    return t
end

---@return SerializedPhysicsEntity
function Mushroom:serialize()
    local mushroom = PhysicsEntity.serialize(self)
    ---@cast mushroom SerializedMushroom
    mushroom.patrolStart = self.patrolStart
    mushroom.patrolEnd = self.patrolEnd
    mushroom.target = self.target
    return mushroom
end

---@param data SerializedMushroom
function Mushroom:applyDeserializedData(data)
    PhysicsEntity.applyDeserializedData(self, data)
    self.patrolStart = data.patrolStart
    self.patrolEnd = data.patrolEnd
    self.target = data.target
end

---@param ldtkData table
function Mushroom:applyLdtkData(ldtkData)
    for _, field in ipairs(ldtkData.fieldInstances) do
        if field.__identifier == "patrolStart" then
            self.patrolStart = { x = field.__value.cx * 16, y = field.__value.cy * 16 }
        end
        if field.__identifier == "patrolEnd" then
            self.patrolEnd = { x = field.__value.cx * 16, y = field.__value.cy * 16 }
        end
    end
    self.target = self.patrolStart
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
    if self.facingLeft then
        self.sprite.flipX = true
    else
        self.sprite.flipX = false
    end
    self.sprite:update()
    self:d(self.fsm:getCurrentStateName(), { self.x, self.y }, { self.target })
end

function Mushroom:draw()
    self.sprite:draw(self.x, self.y)
end

return Mushroom
