local Tile = require("core.map.tile")

---@class TileMapLayer
---@field width number
---@field height number
---@field tileMap TileMap tilemap this layer belongs to
---@field tiles number[][]
---@field tint [number, number, number]
local TileMapLayer = {}

---@param layer table
---@param tileMap TileMap
---@return TileMapLayer
function TileMapLayer:new(layer, tileMap)
    local t = setmetatable({}, { __index = self })
    t.width = layer.width
    t.height = layer.height
    t.tileMap = tileMap
    t.tint = { 1, 1, 1 }
    if layer.tintcolor then
        t.tint = { M.hex_to_rgb(layer.tintcolor) }
    end
    local tileCount = t.width * t.height

    t.tiles = {}
    for i = 1, t.height, 1 do
        table.insert(t.tiles, {})
        for _ = 1, t.width, 1 do
            table.insert(t.tiles[i], 0)
        end
    end

    for tileIndex = 1, tileCount, 1 do
        local tile = layer.data[tileIndex]
        local x = (tileIndex - 1) % t.width + 1
        local y = math.floor((tileIndex - 1) / t.height) + 1
        t.tiles[y][x] = tile
    end

    return t
end

---@param tileset love.Image
function TileMapLayer:draw(tileset)
    local tileSize = self.tileMap.tileSize

    love.graphics.push("all")
    love.graphics.setColor(self.tint)

    local width, height = tileset:getDimensions()
    width = math.floor(width / tileSize)
    height = math.floor(height / tileSize - 1)

    for y, row in ipairs(self.tiles) do
        for x, tileValue in ipairs(row) do
            if tileValue ~= 0 then
                local tileX = (tileValue - 1) % width + 1
                local tileY = math.floor((tileValue - 1) / height) + 1
                local quad = love.graphics.newQuad(
                    tileX * tileSize - tileSize, tileY * tileSize - tileSize,
                    tileSize, tileSize,
                    tileset
                )
                love.graphics.draw(tileset, quad, x * tileSize, y * tileSize)
            end
        end
    end
    love.graphics.pop()
end

---@param x number
---@param y number
---@param w number
---@param h number
---@return Tile[]
function TileMapLayer:getTilesInRectangle(x, y, w, h)
    local tileSize = self.tileMap.tileSize
    local theTiles = {}
    local relativeX = math.floor((x - 0) / tileSize) -- TODO: tile lays might have x, y position. Can replace the 0s here when that's added
    local relativeY = math.floor((y - 0) / tileSize)
    local xCellCount = math.floor(w / tileSize)
    local yCellCount = math.floor(h / tileSize)
    for row = relativeY, yCellCount + relativeY, 1 do
        for column = relativeX, xCellCount + relativeX, 1 do
            if row > 0 and column > 0 and row <= self.height and column <= self.width then
                local value = self.tiles[row][column]
                if value ~= 0 and self.tileMap:tileHasProp(value, "solid") then
                    love.graphics.rectangle("fill", column * tileSize, row * tileSize, tileSize, tileSize)
                    table.insert(theTiles, Tile:new(row, column, value))
                end
            end
        end
    end
    return theTiles
end

return TileMapLayer
