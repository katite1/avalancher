local EntityManager = require("game.entity-manager")
local CollisionManager = require("game.collision-manager")
local Inventory = require("game.inventory")
local GameFSM = require("game.game-fsm")
local Background = require("game.background")
local progressEntries = require("data.progression-entries")

---@class World
---@field mapLoader MapLoader
---@field background Background
---@field entityManager EntityManager
---@field collisionManager CollisionManager
---@field inventory Inventory
---@field fsm GameFSM
---@field tileMap TileMap
---@field properties {gravity: number}
---@field update function
---@field progressEntries ProgressionEntries
local World = {}
World.__index = World

---@return World
function World:new()
    local t = setmetatable({}, { __index = self })
    t.background = Background:new()
    t.entityManager = EntityManager:new(t)
    t.collisionManager = CollisionManager:new(t)
    t.inventory = Inventory:new()
    t.fsm = GameFSM:new(t)
    t.tileMap = nil
    t.properties = {}
    t.properties.gravity = 0.15
    t.progressEntries = progressEntries
    return t
end

---@param target string
function World:travel(target)
    self.entityManager:clearAll()
    self.tileMap = nil
    self.mapLoader:load("maps/" .. target .. ".ldtkl")
end

---@param item Item
function World:pickUp(item)
    self.entityManager:delete(item)
    self.inventory:add(item.template)
end

return World
