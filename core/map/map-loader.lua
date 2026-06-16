local json        = require("lib.json")
local TileMap     = require("core.map.tile-map")
local TileLayer   = require("core.map.tile-map-layer")
local TiledHelper = require("core.map.tiled-helper")
local Player      = require("game.player")
local Portal      = require("game.portal")
local Sign        = require("game.sign")

---@class MapLoader
---@field directory string
---@field world World
local MapLoader   = {}
MapLoader.__index = MapLoader

---@param directory string
---@return MapLoader
function MapLoader:new(directory, world)
    local t = setmetatable({}, { __index = self })
    t.directory = directory
    t.world = world
    return t
end

---@param mapName string
function MapLoader:load(mapName)
    local map = json.decode(love.filesystem.read(self.directory .. mapName))
    local tileMap = TileMap:new(map.tilewidth, self)
    if map.layers then
        for _, layer in ipairs(map.layers) do
            if layer.type == "tilelayer" then
                tileMap:addLayer(layer)
            end
            if layer.type == "objectgroup" then
                self:createObjects(layer)
            end
        end
    end
    if map.tilesets then
        for _, tilesetData in ipairs(map.tilesets) do
            local tileSource = tilesetData.source
            local tileset = json.decode(love.filesystem.read(self.directory .. tileSource))
            if tileset.tiles then
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
                    tileMap:addTileset(tilesetData.firstgid, TILESETS[tileset.image])
                end
            end
        end
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

        if object.type == "portal" then
            e = self.world.entityManager:make(Portal)
            local target = TiledHelper:getPropertyValue(object.properties, "target")
            if not target then
                error("No target defined for portal!")
            end
            e.target = target
        end
        if object.type == "sign" then
            e = self.world.entityManager:make(Sign)
            local dialogueReference = TiledHelper:getPropertyValue(object.properties, "dialogue", "reference")
            if dialogueReference then
                if not DialogueItems[dialogueReference] then
                    error("Dialogue reference doesn't exist: " .. dialogueReference)
                end
                e.dialogueReference = dialogueReference
            else
                error("Dialogue reference doesn't exist: " .. dialogueReference)
            end
        end
        if e then
            e.x = object.x
            e.y = object.y
        end
    end
end

return MapLoader
