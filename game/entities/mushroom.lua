local PhysicsEntity = require("game.entities.base.physics-entity")
local FSM = require("core.fsm")
local FSMState = require("core.fsm-state")

---@class Mushroom: PhysicsEntity
---@field fsm FSM
---@field target {x: number, y: number}
---@field patrolStart {x: number, y: number}
---@field patrolEnd {x: number, y: number}
---@field sprite love.Image
---@field patrolState FSMState
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
    t.patrolState.update = Mushroom.patrolState.update
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
    print("epic sex")
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "patrolStart" then
            print("epic sex")
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
    if math.abs(mushroom.x - mushroom.patrolStart.x) < 4 then
        mushroom.target = mushroom.patrolEnd
    end
    if math.abs(mushroom.x - mushroom.patrolEnd.x) < 4 then
        mushroom.target = mushroom.patrolStart
    end
    if mushroom.x > mushroom.target.x then
        mushroom:walkLeft()
    end
    if mushroom.x < mushroom.target.x then
        mushroom:walkRight()
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
