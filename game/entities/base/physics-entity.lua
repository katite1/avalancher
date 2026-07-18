local Entity = require("game.entities.base.entity")

---@class PhysicsEntity : Entity
---@field vx number
---@field vy number
---@field xRemainder number
---@field yRemainder number
---@field walkSpeed number
---@field maxHorizontalSpeed number
---@field friction number
---@field jumpStrength number
---@field jumpHoldStrength number
---@field jumpHoldMaxFrames number
---@field jumpHoldCurrentFrame number
---@field isJumping boolean
---@field maxFallSpeed number
local PhysicsEntity = {}
PhysicsEntity.__index = PhysicsEntity
setmetatable(PhysicsEntity, Entity)

---@class SerializedPhysicsEntity : SerializedEntity
---@field vx number
---@field vy number
---@field xRemainder number
---@field yRemainder number
---@field walkSpeed number
---@field maxHorizontalSpeed number
---@field friction number
---@field jumpStrength number
---@field jumpHoldStrength number
---@field jumpHoldMaxFrames number
---@field jumpHoldCurrentFrame number
---@field isJumping boolean
---@field maxFallSpeed number

---@param world World
function PhysicsEntity:new(world)
    local t = setmetatable(Entity:new(world), self)
    ---@cast t PhysicsEntity
    t.vx = 0
    t.vy = 0
    t.xRemainder = 0
    t.yRemainder = 0

    t.walkSpeed = 0.45
    t.maxHorizontalSpeed = 10
    t.friction = 0.75

    t.jumpStrength = 2
    t.jumpHoldStrength = 0.2
    t.jumpHoldCurrentFrame = 0
    t.jumpHoldMaxFrames = 8
    t.maxFallSpeed = 10
    return t
end

---@return SerializedPhysicsEntity
function PhysicsEntity:serialize()
    local entity = Entity.serialize(self)
    ---@cast entity SerializedPhysicsEntity
    entity.vx, entity.vy = self.vx, self.vy
    entity.xRemainder, entity.yRemainder = self.xRemainder, self.yRemainder
    entity.walkSpeed = self.walkSpeed
    entity.friction = self.friction
    entity.jumpStrength = self.jumpStrength
    entity.jumpHoldStrength = self.jumpHoldStrength
    entity.jumpHoldMaxFrames = self.jumpHoldMaxFrames
    entity.jumpHoldCurrentFrame = self.jumpHoldCurrentFrame
    entity.isJumping = self.isJumping
    entity.maxFallSpeed = self.maxFallSpeed
    return entity
end

---@param data SerializedPhysicsEntity
---@return PhysicsEntity
function PhysicsEntity.deserialize(data, world)
    local entity = Entity.deserialize(data, world)
    setmetatable(entity, PhysicsEntity) -- TODO: there should be a better way to do this
    ---@cast entity PhysicsEntity
    entity.vx, entity.vy = data.vx, data.vy
    entity.xRemainder, entity.yRemainder = data.xRemainder, data.yRemainder
    entity.walkSpeed = data.walkSpeed
    entity.friction = data.friction
    entity.jumpStrength = data.jumpStrength
    entity.jumpHoldStrength = data.jumpHoldStrength
    entity.jumpHoldMaxFrames = data.jumpHoldMaxFrames
    entity.jumpHoldCurrentFrame = data.jumpHoldCurrentFrame
    entity.isJumping = data.isJumping
    entity.maxFallSpeed = data.maxFallSpeed
    return entity
end

function PhysicsEntity:update()
    Entity.update(self)

    if self.vy >= 0 then
        self.isJumping = false
        self.jumpHoldCurrentFrame = 1
    end
    if self:onFloor() then
        self.vy = math.min(0, self.vy)
    else
        self.vy = self.vy + self.world.properties.gravity
    end

    if self:onCeiling() and self.vy < 0 then
        self.vy = -self.vy * 0.5
    end

    self.vx = self.vx * self.friction
    local xBonk = self:moveX(self.vx)
    if xBonk then
        self.vx = 0
    end
    self:moveY(self.vy)
end

---@return boolean
function PhysicsEntity:onFloor()
    self.y = self.y + 1;
    local collisions = self.world.collisionManager:getCollisions(self)
    self.y = self.y - 1;
    return collisions
end

---@return boolean
function PhysicsEntity:onCeiling()
    self.y = self.y - 1;
    local collisions = self.world.collisionManager:getCollisions(self)
    self.y = self.y + 1;
    return collisions
end

function PhysicsEntity:jump()
    if self:onFloor() then
        self.isJumping = true
        self.vy = self.vy - self.jumpStrength
    end
end

function PhysicsEntity:jumpHold()
    if self.isJumping and self:onFloor() == false and self.jumpHoldCurrentFrame < self.jumpHoldMaxFrames then
        self.vy = self.vy - self.jumpHoldStrength
        self.jumpHoldCurrentFrame = self.jumpHoldCurrentFrame + 1
    end
end

function PhysicsEntity:walkLeft()
    self.vx = self.vx - self.walkSpeed
end

function PhysicsEntity:walkRight()
    self.vx = self.vx + self.walkSpeed
end

function PhysicsEntity:moveX(amount)
    self.xRemainder = self.xRemainder + amount
    local move = M.round(self.xRemainder)
    if move ~= 0 then
        self.xRemainder = self.xRemainder - move
        local sign = M.sign(move)
        while move ~= 0 do
            self.x = self.x + sign;
            if not self.world.collisionManager:getCollisions(self) then
                move = move - sign
            else
                self.x = self.x - sign;
                return true
            end
        end
    end
    return false
end

function PhysicsEntity:moveY(amount)
    self.yRemainder = self.yRemainder + amount
    local move = M.round(self.yRemainder)
    if move ~= 0 then
        self.yRemainder = self.yRemainder - move
        local sign = M.sign(move)
        while move ~= 0 do
            self.y = self.y + sign;
            if not self.world.collisionManager:getCollisions(self) then
                move = move - sign
            else
                self.y = self.y - sign;
                return true
            end
        end
    end
    return false
end

return PhysicsEntity
