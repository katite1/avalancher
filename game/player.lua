local Entity = require("game.entity")

---@class Player: Entity
local Player = {}
Player.__index = Player

---@return Player
function Player:new()
    setmetatable(Player, { __index = Entity })
    local t = setmetatable(Entity:new(), self)
    ---@cast t Player
    return t
end

function Player:draw()
    love.graphics.rectangle("line", self.x, self.y, 32, 24)
end

return Player
