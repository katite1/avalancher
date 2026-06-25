local Tile = require("core.map.tile")

---@class TileMapLayer
---@field width number
---@field height number
---@field tileMap TileMap tilemap this layer belongs to
---@field tileset Tileset
---@field tileGrid Tile[][]|Tile[][][]
---@field spriteBatch love.SpriteBatch
---@field tint [number, number, number]
---@field tags string[]
local TileMapLayer = {}
TileMapLayer.__index = TileMapLayer

---@param layer table
---@param width integer
---@param height integer
---@param tileMap TileMap
---@return TileMapLayer
function TileMapLayer:new(layer, width, height, tags, tileMap)
    local t = setmetatable({}, { __index = self })
    t.tileMap = tileMap
    t.tileset = t.tileMap:getTileset(layer.__tilesetRelPath)
    t.decorative = false
    t.tint = { 1, 1, 1 }
    t.width = width
    t.height = height
    t.tags = tags
    t.spriteBatch = love.graphics.newSpriteBatch(t.tileset.image)

    t.tileGrid = {}

    for i = 1, t.height, 1 do
        table.insert(t.tileGrid, {})
        for j = 1, t.width, 1 do
            table.insert(t.tileGrid[i], Tile:new(i * 16 - 16, j * 16 - 16, 16, 16, -1))
        end
    end

    for i = 1, #layer.autoLayerTiles, 1 do
        local tileData = layer.autoLayerTiles[i]
        local tile = t.tileGrid[tileData.px[2] / 16 + 1][tileData.px[1] / 16 + 1]
        if tile ~= nil then
            if tile.value ~= -1 then -- this means there is a tile at this coord already
                local newTile = Tile:new(tile.x, tile.y, tile.width, tile.height, tileData.t)
                if #tile > 1 then
                    table.insert(tile, newTile)
                else
                    local tiles = {}
                    table.insert(tiles, tile)
                    table.insert(tiles, newTile)
                    t.tileGrid[tileData.px[2] / 16 + 1][tileData.px[1] / 16 + 1] = tiles
                    -- so we store both tiles in a table now
                    newTile.value = tileData.t
                    if tileData.f == 1 then
                        newTile.flipX = true
                    elseif tileData.f == 2 then
                        newTile.flipY = true
                    elseif tileData.f == 3 then
                        newTile.flipX = true
                        newTile.flipY = true
                    end
                end
            else
                tile.value = tileData.t
                if tileData.f == 1 then
                    tile.flipX = true
                elseif tileData.f == 2 then
                    tile.flipY = true
                elseif tileData.f == 3 then
                    tile.flipX = true
                    tile.flipY = true
                end
            end
        end
    end

    return t
end

function TileMapLayer:draw()
    local tileSize = self.tileMap.tileSize

    love.graphics.push("all")
    love.graphics.setColor(self.tint)

    self.spriteBatch:clear()

    for y, row in ipairs(self.tileGrid) do
        for x, tile in ipairs(row) do
            local tiles = {}
            if tile[1] ~= nil then
                tiles = tile
            else
                tiles = { tile }
            end
            for _, tile in ipairs(tiles) do
                if tile.value ~= -1 then
                    local quad = self.tileset.quads[tile.value + 1]

                    local originOffset = 0
                    local scaleX = tile.flipX and -1 or 1
                    local scaleY = tile.flipY and -1 or 1
                    if scaleX == -1 or scaleY == -1 then
                        originOffset = tileSize / 2
                    end

                    self.spriteBatch:add(quad, x * tileSize + originOffset, y * tileSize + originOffset, 0, scaleX,
                        scaleY,
                        originOffset,
                        originOffset)
                end
            end
        end
    end
    love.graphics.draw(self.spriteBatch)
    love.graphics.pop()
end

---@param tag string
---@return boolean
function TileMapLayer:hasTag(tag)
    for _, value in ipairs(self.tags) do
        if value == tag then
            return true
        end
    end
    return false
end

---@param x number
---@param y number
---@param w number
---@param h number
---@return Tile[]
function TileMapLayer:getTilesInRectangle(x, y, w, h)
    if self:hasTag("decoration") then
        return {}
    end
    -- not sure how the math adds up here but seems like we need to extend the hitbox a bit to avoid collision.
    -- i'm too sleepy to understand this but it fixes it for now!!
    x = x - 1
    y = y - 1
    w = w + 1
    h = h + 1
    local tileSize = self.tileMap.tileSize
    local tilesInRectangle = {}
    local startX = math.floor((x) / tileSize)
    local startY = math.floor((y) / tileSize)
    local xCells = math.floor((x % tileSize + w - 1) / tileSize)
    local yCells = math.floor((y % tileSize + h - 1) / tileSize)
    for row = startY, yCells + startY, 1 do
        for column = startX, xCells + startX, 1 do
            if row > 0 and column > 0 and row <= self.height and column <= self.width then
                local tile = self.tileGrid[row][column]
                -- if value ~= -1 and self.tileMap:tileHasProp(value, "solid") then
                if tile.value ~= -1 then
                    table.insert(tilesInRectangle, tile)
                end
            end
        end
    end
    return tilesInRectangle
end

return TileMapLayer
