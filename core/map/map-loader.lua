local json      = require("lib.json")
local TileMap   = require("core.map.tile-map")
local TileLayer = require("core.map.tile-map-layer")
local Tile      = require("core.map.tile")


---@class MapLoader
---@field directory string
---@field tileset love.Image
local MapLoader = {}

---@param directory string
---@param tileset love.Image
---@return MapLoader
function MapLoader:new(directory, tileset)
    local t = setmetatable({}, { __index = self })
    t.directory = directory
    t.tileset = tileset
    return t
end

---@param mapName string
---@return TileMap | false
function MapLoader:load(mapName)
    local map = json.decode(love.filesystem.read(self.directory .. mapName))
    local tileMap = TileMap:new(map.tilewidth, self.tileset)
    if map.layers then
        for _, layer in ipairs(map.layers) do
            table.insert(
                tileMap.layers,
                TileLayer:new(layer, tileMap)
            )
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
    return tileMap
end

return MapLoader
