local EntityManager = require "game.entity-manager"
local CollisionManager = require "game.collision-manager"

---@class World
---@field entityManager EntityManager
---@field collisionManager CollisionManager
---@field tileMap TileMap
---@field properties {gravity: number}
local World = {}
World.__index = World

---@param tileMap TileMap
---@return World
function World:new(tileMap)
    local t = setmetatable({}, { __index = self })
    t.entityManager = EntityManager:new(t)
    t.collisionManager = CollisionManager:new(t)
    t.tileMap = tileMap
    t.properties = {}
    t.properties.gravity = 0.1
    return t
end

return World
