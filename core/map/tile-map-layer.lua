local TiledHelper = require("core.map.tiled-helper")
local Tile = require("core.map.tile")

---@class TileMapLayer
---@field width number
---@field height number
---@field tileMap TileMap tilemap this layer belongs to
---@field tileset Tileset
---@field tiles number[][]
---@field tint [number, number, number]
---@field decorative boolean
local TileMapLayer = {}
TileMapLayer.__index = TileMapLayer

---@param layer table
---@param width integer
---@param height integer
---@param tileMap TileMap
---@return TileMapLayer
function TileMapLayer:new(layer, width, height, tileMap)
    local t = setmetatable({}, { __index = self })
    t.tileMap = tileMap
    t.tileset = t.tileMap:getTileset(layer.__tilesetRelPath)
    t.decorative = false
    t.tint = { 1, 1, 1 }
    t.width = width
    t.height = height

    -- t.decorative = TiledHelper.hasPropertyValue(layer.properties, "layer", "decorative")
    -- if layer.tintcolor then
    --     t.tint = { M.hex_to_rgb(layer.tintcolor) }
    -- end
    -- local tileCount = t.width * t.height

    t.tiles = {}
    for i = 1, t.height, 1 do
        table.insert(t.tiles, {})
        for _ = 1, t.width, 1 do
            table.insert(t.tiles[i], -1)
        end
    end

    for i = 1, #layer.autoLayerTiles, 1 do
        local tile = layer.autoLayerTiles[i]
        t.tiles[tile.px[2] / 16 + 1][tile.px[1] / 16 + 1] = tile.t
    end

    return t
end

function TileMapLayer:draw()
    local tileSize = self.tileMap.tileSize

    love.graphics.push("all")
    love.graphics.setColor(self.tint)

    local spriteBatch = love.graphics.newSpriteBatch(self.tileset.image)

    for y, row in ipairs(self.tiles) do
        for x, tileValue in ipairs(row) do
            if tileValue ~= -1 then
                local width, height = self.tileset.image:getDimensions()
                width = math.floor(width / tileSize)
                height = math.floor(height / tileSize)

                local quad = self.tileset.quads[tileValue + 1]
                spriteBatch:add(quad, x * tileSize, y * tileSize)
            end
        end
    end
    love.graphics.draw(spriteBatch)
    love.graphics.pop()
end

---@param x number
---@param y number
---@param w number
---@param h number
---@return Tile[]
function TileMapLayer:getTilesInRectangle(x, y, w, h)
    if self.decorative then
        return {}
    end
    -- not sure how the math adds up here but seems like we need to extend the hitbox a bit to avoid collision.
    -- i'm too sleepy to understand this but it fixes it for now!!
    x = x - 1
    y = y - 1
    w = w + 1
    h = h + 1
    local tileSize = self.tileMap.tileSize
    local theTiles = {}
    local startX = math.floor((x) / tileSize)
    local startY = math.floor((y) / tileSize)
    local xCells = math.floor((x % tileSize + w - 1) / tileSize)
    local yCells = math.floor((y % tileSize + h - 1) / tileSize)
    for row = startY, yCells + startY, 1 do
        for column = startX, xCells + startX, 1 do
            if row > 0 and column > 0 and row <= self.height and column <= self.width then
                local value = self.tiles[row][column]
                -- if value ~= -1 and self.tileMap:tileHasProp(value, "solid") then
                if value ~= -1 then
                    table.insert(theTiles, Tile:new(row, column, tileSize, tileSize, value))
                end
            end
        end
    end
    return theTiles
end

return TileMapLayer
