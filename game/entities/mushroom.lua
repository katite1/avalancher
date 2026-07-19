local PhysicsEntity = require("game.entities.base.physics-entity")
local FSM = require("core.fsm")
local FSMState = require("core.fsm-state")
local Timer = require("core.timer")

---@class Mushroom: PhysicsEntity
---@field fsm FSM
---@field target {x: number, y: number}
---@field patrolStart {x: number, y: number}
---@field patrolEnd {x: number, y: number}
---@field sprite love.Image
---@field patrolState FSMState
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
    t.sprite = SPRITES.MUSHROOM
    t.patrolStart = { x = 0, y = 0 }
    t.patrolEnd = { x = 0, y = 0 }
    t.fsm = FSM:new(t)
    t.patrolState = FSMState:new(t)
    setmetatable(t.patrolState, { __index = Mushroom.patrolState })
    t.patrolWaitState = FSMState:new(t)
    setmetatable(t.patrolWaitState, { __index = Mushroom.patrolWaitState })
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

---@diagnostic disable-next-line: missing-fields
Mushroom.patrolState = {}
function Mushroom.patrolState:update()
    local mushroom = self.context
    ---@cast mushroom Mushroom
    if mushroom.x > mushroom.target.x then
        mushroom:walkLeft()
    end
    if mushroom.x < mushroom.target.x then
        mushroom:walkRight()
    end

    if math.abs(mushroom.x - mushroom.target.x) < 4 then
        if mushroom.target.x == mushroom.patrolStart.x then
            mushroom.target = mushroom.patrolEnd
        else
            mushroom.target = mushroom.patrolStart
        end

        mushroom.fsm:gotoState(mushroom.patrolWaitState)
    end
end

---@diagnostic disable-next-line: missing-fields
Mushroom.patrolWaitState = {}
function Mushroom.patrolWaitState:enter()
    local mushroom = self.context
    ---@cast mushroom Mushroom

    self.jumpTimer = Timer:new(50, function()
        mushroom:jump()
    end)
    self.waitTimer = Timer:new(100, function()
        mushroom.fsm:gotoState(mushroom.patrolState)
    end)
end

function Mushroom.patrolWaitState:update()
    self.waitTimer:update()
    self.jumpTimer:update()
end

function Mushroom:update()
    PhysicsEntity.update(self)
    self.fsm:update()
end

function Mushroom:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Mushroom
