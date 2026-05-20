---@class TileMap
---@field tileSize number
---@field tileset love.Image
---@field tileProperties string[][]
---@field layers TileMapLayer[]
local TileMap = {}

---@param tileSize number
---@param tileset love.Image
---@return TileMap
function TileMap:new(tileSize, tileset)
    local t = setmetatable({}, { __index = self })
    t.tileSize = tileSize
    t.tiles = {}
    t.tileProperties = {}
    t.tileset = tileset
    t.layers = {}
    return t
end

function TileMap:draw()
    for _, layer in ipairs(self.layers) do
        layer:draw(self.tileset)
    end
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

---@param tile number
---@param property string
---@return boolean
function TileMap:tileHasProp(tile, property)
    if self.tileProperties[tile] == nil then
        return false
    end
    for _, value in ipairs(self.tileProperties[tile]) do
        if value == property then
            return true
        end
    end
    return false
end

return TileMap
