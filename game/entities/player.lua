local PhysicsEntity = require("game.entities.base.physics-entity")

---@class Player: PhysicsEntity
---@field sprite love.Image
local Player = {}
Player.__index = Player
setmetatable(Player, PhysicsEntity)

---@class SerializedPlayer : SerializedPhysicsEntity

---@param world World
---@return Player
function Player:new(world)
    local t = setmetatable(PhysicsEntity:new(world), self)
    t.type = "player"
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    t.sprite = SPRITES.PLAYER
    ---@cast t Player
    return t
end

function Player.deserialize(data, world)
    local player = PhysicsEntity.deserialize(data, world)
    setmetatable(player, Player)
    ---@cast player Player
    player.type = "player"
    player.sprite = SPRITES.PLAYER
    return player
end

function Player:update()
    PhysicsEntity.update(self)
    if Buttons.left.pressed then
        self:walkLeft()
    end
    if Buttons.right.pressed then
        self:walkRight()
    end
    if Buttons.jump.justPressed then
        self:jump()
    end
    if not Buttons.jump.justPressed and Buttons.jump.pressed then
        self:jumpHold()
    end

    local collidingEntities = self.world.entityManager:getOverlapping(self)
    D:write(#collidingEntities)
    D:write(collidingEntities)
    if #collidingEntities > 0 then
        D:breakpoint()
    end
end

function Player:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Player
