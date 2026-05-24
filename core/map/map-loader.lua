local json        = require("lib.json")
local TileMap     = require("core.map.tile-map")
local TileLayer   = require("core.map.tile-map-layer")
local Player      = require("game.player")

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
    for _, tile in ipairs(map.tilesets[1].tiles) do
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
        if object.type == "player" then
            local e = self.world.entityManager:make(Player)
            e.x = object.x
            e.y = object.y
        end
    end
end

return MapLoader
