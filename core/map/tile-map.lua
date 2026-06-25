local TileMapLayer = require("core.map.tile-map-layer")
local Tileset = require("core.map.tileset")

---@class TileMap
---@field tileSize number
---@field width integer
---@field height integer
---@field tileProperties string[][]
---@field layers TileMapLayer[]
---@field tilesets Tileset[]
local TileMap = {}

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

---@param data table Tiled layer data
---@param tags table<string>
---@return TileMapLayer
function TileMap:addLayer(data, tags)
    local layer = TileMapLayer:new(data, self.width, self.height, tags, self)
    table.insert(self.layers, 1, layer)
    return layer
end

---@param name string
---@param image love.Image
function TileMap:addTileset(name, image)
    self.tilesets[name] = Tileset:new(image)
end

---@param name string
---@return Tileset
function TileMap:getTileset(name)
    if self.tilesets[name] then
        return self.tilesets[name]
    end

    error("no tileset for tile of name: " .. name)
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

return TileMap
