local TileMapLayer = require("core.map.tile-map-layer")
local Tileset = require("core.map.tileset")

---@class TileMap
---@field tileSize number
---@field width integer
---@field height integer
---@field tileProperties string[][]
---@field layers TileMapLayer[]
---@field tilesets {[string]: Tileset}
local TileMap = {}

---@class SerializedTileMap
---@field tileSize number
---@field width integer
---@field height integer
---@field tileProperties string[][]
---@field layers SerializedTileMapLayer[]
---@field tilesets SerializedTileset[]

---@param tileSize number
---@param width integer
---@param height integer
---@return TileMap
function TileMap:new(tileSize, width, height)
    local t = setmetatable({}, { __index = self })
    t.tileSize = tileSize
    t.width = width
    t.height = height
    t.tiles = {}
    t.tileProperties = {}
    t.tilesets = {}
    t.layers = {}
    return t
end

function TileMap:draw()
    for _, layer in ipairs(self.layers) do
        layer:draw()
    end
end

---@param layer TileMapLayer
---@return TileMapLayer
function TileMap:addLayer(layer)
    table.insert(self.layers, 1, layer)
    return layer
end

---@param data table Tiled layer data
---@param tags table<string>
---@return TileMapLayer
function TileMap:deserializeLdtkLayer(data, tags)
    local layer = TileMapLayer:deserializeLdtk(data, tags, self)
    table.insert(self.layers, 1, layer)
    return layer
end

---@param directory string
---@param filename string
---@return Tileset
function TileMap:addTileset(directory, filename)
    local tileset = Tileset:new(directory, filename)
    self.tilesets[filename] = tileset
    return tileset
end

---@param name string
---@return Tileset
function TileMap:getTileset(name)
    if self.tilesets[name] then
        return self.tilesets[name]
    end

    error("No valid tileset exists")
end

---@param x number
---@param y number
---@param w number
---@param h number
---@return Tile[]
function TileMap:getTilesInRectangle(x, y, w, h)
    local theTiles = {}
    for _, layer in ipairs(self.layers) do
        local tiles = layer:getTilesInRectangle(x, y, w, h)
        for _, tile in ipairs(tiles) do
            table.insert(theTiles, tile)
        end
    end
    return theTiles
end

---@return SerializedTileMap
function TileMap:serialize()
    local tilesets = {}
    for _, tileset in pairs(self.tilesets) do
        table.insert(tilesets, tileset:serialize())
    end

    local layers = {}
    for _, layer in ipairs(self.layers) do
        table.insert(layers, layer:serialize())
    end

    ---@type SerializedTileMap
    return {
        tileSize = self.tileSize,
        width = self.width,
        height = self.height,
        tileProperties = self.tileProperties,
        layers = layers,
        tilesets = tilesets
    }
end

---@param data SerializedTileMap
---@return TileMap
function TileMap.deserialize(data)
    local tilemap = TileMap:new(data.tileSize, data.width, data.height)

    for _, tileset in ipairs(data.tilesets) do
        tilemap:addTileset(tileset.imageDirectory, tileset.imageFilename)
    end
    for i = #data.layers, 1, -1 do
        tilemap:addLayer(TileMapLayer.deserialize(data.layers[i], tilemap))
    end
    return tilemap
end

return TileMap
