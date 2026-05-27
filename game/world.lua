local EntityManager = require("game.entity-manager")
local CollisionManager = require("game.collision-manager")
local GameFSM = require("game.game-fsm")

---@class World
---@field entityManager EntityManager
---@field collisionManager CollisionManager
---@field fsm GameFSM
---@field tileMap TileMap
---@field properties {gravity: number}
---@field update function
local World = {}
World.__index = World

---@return World
function World:new()
    local t = setmetatable({}, { __index = self })
    t.entityManager = EntityManager:new(t)
    t.collisionManager = CollisionManager:new(t)
    t.fsm = GameFSM:new(t)
    t.tileMap = nil
    t.properties = {}
    t.properties.gravity = 0.1
    return t
end

return World
