local Entity = require("game.entity")

---@class PhysicsEntity : Entity
---@field vx number
---@field vy number
---@field xRemainder number
---@field yRemainder number
---@field walkSpeed number
---@field maxHorizontalSpeed number
---@field friction number
---@field jumpStrength number
---@field maxFallSpeed number
local PhysicsEntity = {}
setmetatable(PhysicsEntity, { __index = Entity })

function PhysicsEntity:new()
    local t = setmetatable(Entity:new(), self)
    ---@cast t PhysicsEntity
    t.vx = 0
    t.vy = 0
    t.w = 16
    t.h = 16
    t.bb = { x = t.x, y = t.y, w = t.w, h = t.h }
    t.xRemainder = 0
    t.yRemainder = 0

    t.walkSpeed = 2
    t.maxHorizontalSpeed = 10
    t.friction = 0.8

    t.jumpStrength = 5
    t.maxFallSpeed = 10
    return t
end

function PhysicsEntity:update()
    Entity.update(self)
    if self:onFloor() then
        self.vy = math.min(0, self.vy)
    else
        self.vy = self.vy + self.world.properties.gravity
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

function PhysicsEntity:jump()
    if self:onFloor() then
        self.vy = self.vy - self.jumpStrength
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
