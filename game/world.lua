local EntityManager    = require("game.entity-manager")
local CollisionManager = require("game.collision-manager")
local Inventory        = require("game.inventory")
local GameFSM          = require("game.game-fsm")
local Background       = require("game.background")
local ProgressEntries  = require("data.progression-entries")
local TileMap          = require("core.map.tile-map")
local json             = require("lib.json")

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
local World            = {}
World.__index          = World

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
    t.progressEntries = ProgressEntries
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
    self.inventory:add(item.name)
end

function World:save()
    local saveData = {}
    saveData.inventory = self.inventory:serialize()
    saveData.progressEntries = self.progressEntries:serialize()
    saveData.tilemap = self.tileMap:serialize()
    love.filesystem.write("save.json", json.encode(saveData))
end

function World:load()
    local saveFile = love.filesystem.read("save.json")
    if not saveFile then
        return
    end
    local saveData = json.decode(saveFile)
    self.inventory = Inventory.deserialize(saveData.inventory)
    self.progressEntries = ProgressEntries.deserialize(saveData.progressEntries)
    self.tileMap = TileMap.deserialize(saveData.tilemap)
end

return World
