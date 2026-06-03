local json        = require("lib.json")
local TileMap     = require("core.map.tile-map")
local TileLayer   = require("core.map.tile-map-layer")
local TiledHelper = require("core.map.tiled-helper")
local Player      = require("game.player")
local Sign        = require("game.sign")
local Dialogue    = require("game.dialogue")

---@class MapLoader
---@field directory string
---@field tileset love.Image
---@field world World
local MapLoader   = {}
MapLoader.__index = MapLoader

---@param directory string
---@param tileset love.Image
---@return MapLoader
function MapLoader:new(directory, tileset, world)
    local t = setmetatable({}, { __index = self })
    t.directory = directory
    t.tileset = tileset
    t.world = world
    return t
end

---@param mapName string
function MapLoader:load(mapName)
    local map = json.decode(love.filesystem.read(self.directory .. mapName))
    local tileMap = TileMap:new(map.tilewidth, self.tileset)
    if map.layers then
        for _, layer in ipairs(map.layers) do
            if layer.type == "tilelayer" then
                table.insert(
                    tileMap.layers,
                    TileLayer:new(layer, tileMap)
                )
            end
            if layer.type == "objectgroup" then
                self:createObjects(layer)
            end
        end
    end
    local tileSource = map.tilesets[1].source
    local tileset = json.decode(love.filesystem.read(self.directory .. tileSource))
    for _, tile in ipairs(tileset.tiles) do
        local props = {}
        for prop, _ in pairs(tile.properties[1].value) do
            table.insert(props, prop)
        end
        table.insert(
            tileMap.tileProperties,
            tile.id + 1,
            props
        )
    end
    self.world.tileMap = tileMap
end

---@param layer table
function MapLoader:createObjects(layer)
    for _, object in ipairs(layer.objects) do
        local e = nil
        if object.type == "player" then
            e = self.world.entityManager:make(Player)
        end
        if object.type == "sign" then
            e = self.world.entityManager:make(Sign)
            local dialogueReference = TiledHelper:getPropertyValue(object.properties, "dialogue", "reference")
            if dialogueReference then
                if not DialogueItems[dialogueReference] then
                    error("Dialogue reference doesn't exist: " .. dialogueReference)
                end
                e.dialogueReference = dialogueReference
            end
        end
        if e then
            e.x = object.x
            e.y = object.y
        end
    end
end

return MapLoader
