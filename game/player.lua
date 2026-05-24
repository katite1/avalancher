local PhysicsEntity = require("game.physics-entity")

---@class Player: PhysicsEntity
---@field sprite love.Image
local Player = {}
Player.__index = Player
setmetatable(Player, PhysicsEntity)

---@return Player
function Player:new()
    local t = setmetatable(PhysicsEntity:new(), self)
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    t.sprite = SPRITES.PLAYER
    ---@cast t Player
    return t
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
end

function Player:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
    love.graphics.rectangle("line", self.x + self.bb.x, self.y + self.bb.y, self.bb.w, self.bb.h)
end

return Player
