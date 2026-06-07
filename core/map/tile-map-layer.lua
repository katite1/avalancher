local TiledHelper = require("core.map.tiled-helper")
local Tile = require("core.map.tile")

---@class TileMapLayer
---@field width number
---@field height number
---@field tileMap TileMap tilemap this layer belongs to
---@field tiles number[][]
---@field tint [number, number, number]
---@field decorative boolean
local TileMapLayer = {}
TileMapLayer.__index = TileMapLayer

---@param layer table
---@param tileMap TileMap
---@return TileMapLayer
function TileMapLayer:new(layer, tileMap)
    local t = setmetatable({}, { __index = self })
    t.width = layer.width
    t.height = layer.height
    t.tileMap = tileMap
    t.decorative = false
    t.tint = { 1, 1, 1 }

    t.decorative = TiledHelper.hasPropertyValue(layer.properties, "layer", "decorative")
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

function TileMapLayer:draw()
    local tileSize = self.tileMap.tileSize

    love.graphics.push("all")
    love.graphics.setColor(self.tint)

    -- local batch = love.graphics.newSpriteBatch()
    local batches = {}
    ---@cast batches love.SpriteBatch[]

    for y, row in ipairs(self.tiles) do
        for x, tileValue in ipairs(row) do
            if tileValue ~= 0 then
                local tileset = self.tileMap:getTilemapForTile(tileValue)
                if batches[tileset.firstID] == nil then
                    batches[tileset.firstID] = love.graphics.newSpriteBatch(tileset.image)
                end

                tileValue = tileValue - tileset.firstID + 1
                local width, height = tileset.image:getDimensions()
                width = math.floor(width / tileSize)
                height = math.floor(height / tileSize)

                local quad = tileset.quads[tileValue]
                batches[tileset.firstID]:add(quad, x * tileSize, y * tileSize)
            end
        end
    end
    for _, batch in pairs(batches) do
        love.graphics.draw(batch)
    end
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
                if value ~= 0 and self.tileMap:tileHasProp(value, "solid") then
                    table.insert(theTiles, Tile:new(row, column, tileSize, tileSize, value))
                end
            end
        end
    end
    return theTiles
end

return TileMapLayer
