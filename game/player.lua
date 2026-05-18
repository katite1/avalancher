local Entity = require("game.entity")

---@class Player: Entity
local Player = {}

---@return Player
function Player:new()
    local t = setmetatable(Entity:new(), { __index = self })
    ---@cast t Player
    return t
end

function Player:draw()
    love.graphics.rectangle("line", self.x, self.y, 8, 16)
end

return Player
