local Tile = require("core.map.tile")

---@class TileMapLayer
---@field tileMap TileMap tilemap this layer belongs to
---@field tilesetName string
---@field cells Tile[][][]
---@field spriteBatch love.SpriteBatch
---@field tint [number, number, number]
---@field tags string[]
---@field dirty boolean whether tilemap has changed and needs to remake the spritebatch
local TileMapLayer = {}
TileMapLayer.__index = TileMapLayer

---@param cells Tile[][][]
---@param tags string[]
---@param tileMap TileMap
---@param tilesetName string
---@return TileMapLayer
function TileMapLayer:new(cells, tags, tileMap, tilesetName)
    local t = setmetatable({}, { __index = self })
    ---@cast t TileMapLayer
    t.tileMap = tileMap
    t.tilesetName = tilesetName
    t.tint = { 1, 1, 1 }
    t.tags = tags
    t.spriteBatch = love.graphics.newSpriteBatch(t.tileMap:getTileset(t.tilesetName).image)
    t.cells = cells
    t.dirty = true
    return t
end

---@class SerializedTileMapLayer
---@field tilesetName string
---@field cells SerializedTile[]
---@field tint [number, number, number]
---@field tags string[]

---@return SerializedTileMapLayer
function TileMapLayer:serialize()
    local layer = {}
    ---@cast layer SerializedTileMapLayer
    layer.tilesetName = self.tilesetName

    layer.cells = {}
    for i, cellRow in ipairs(self.cells) do
        for j, cell in ipairs(cellRow) do
            -- table.insert(layer.cells[i], {})
            for _, tile in ipairs(cell) do
                table.insert(layer.cells, tile:serialize())
            end
        end
    end

    layer.tint = self.tint
    layer.tags = self.tags
    return layer
end

---@param data SerializedTileMapLayer
---@param tilemap TileMap
---@return TileMapLayer
function TileMapLayer.deserialize(data, tilemap)
    local cells = {}

    for i = 1, tilemap.height, 1 do
        table.insert(cells, {})
        for j = 1, tilemap.width, 1 do
            table.insert(cells[i], {})
        end
    end
    for i = 1, #data.cells, 1 do
        local tileData = data.cells[i]
        local gridX = M.round(tileData.x / 16 + 1)
        local gridY = M.round(tileData.y / 16 + 1)
        local x = (gridX - 1) * 16
        local y = (gridY - 1) * 16
        local offsetX = tileData.offsetX
        local offsetY = tileData.offsetY
        local cell = cells[gridY][gridX]
        local newTile = Tile:new(x, y, 16, 16, tileData.value, offsetX, offsetY)
        table.insert(cell, newTile)
        newTile.flipX = tileData.flipX
        newTile.flipY = tileData.flipY
    end

    return TileMapLayer:new(cells, data.tags, tilemap, data.tilesetName)
end

---@param data table
---@param tags string[]
---@param tileMap TileMap
---@return TileMapLayer
function TileMapLayer:deserializeLdtk(data, tags, tileMap)
    local tilesetName = data.__tilesetRelPath
    local cells = {}

    for i = 1, tileMap.height, 1 do
        table.insert(cells, {})
        for j = 1, tileMap.width, 1 do
            table.insert(cells[i], {})
        end
    end
    for i = 1, #data.autoLayerTiles, 1 do
        local tileData = data.autoLayerTiles[i]
        local gridX = M.round(tileData.px[1] / 16 + 1)
        local gridY = M.round(tileData.px[2] / 16 + 1)
        local x = (gridX - 1) * 16
        local y = (gridY - 1) * 16
        local offsetX = tileData.px[1] - x
        local offsetY = tileData.px[2] - y
        local cell = cells[gridY][gridX]
        local newTile = Tile:new(x, y, 16, 16, tileData.t, offsetX, offsetY)
        table.insert(cell, newTile)
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

    local layer = TileMapLayer:new(cells, tags, tileMap, tilesetName)
    return layer
end

function TileMapLayer:draw()
    local tileSize = self.tileMap.tileSize
    local tileset = self.tileMap:getTileset(self.tilesetName)

    love.graphics.push("all")
    love.graphics.setColor(self.tint)
    if self.dirty == false then
        love.graphics.draw(self.spriteBatch)
        love.graphics.pop()
        return
    end

    self.spriteBatch:clear()

    for y, row in ipairs(self.cells) do
        for x, cell in ipairs(row) do
            for _, tile in ipairs(cell) do
                if tile.value > -1 then
                    local quad = tileset.quads[tile.value + 1]

                    local originOffset = 0
                    local scaleX = tile.flipX and -1 or 1
                    local scaleY = tile.flipY and -1 or 1
                    if scaleX == -1 or scaleY == -1 then
                        originOffset = tileSize / 2
                    end

                    self.spriteBatch:add(
                        quad,
                        x * tileSize - tileSize + tile.offsetX + originOffset,
                        y * tileSize - tileSize + tile.offsetY + originOffset,
                        0,
                        scaleX,
                        scaleY,
                        originOffset,
                        originOffset)
                end
            end
        end
    end
    love.graphics.draw(self.spriteBatch)
    love.graphics.pop()
    self.dirty = false
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

---@param rectangle Rectangle
---@return Tile[]
function TileMapLayer:getTilesInRectangle(rectangle)
    local x = rectangle.x
    local y = rectangle.y
    local w = rectangle.w
    local h = rectangle.h
    if self:hasTag("decoration") then
        return {}
    end
    -- not sure how the math adds up here but seems like we need to extend the hitbox a bit to avoid collision.
    -- i'm too sleepy to understand this but it fixes it for now!!
    x = x - 1 + 16
    y = y - 1 + 16
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
            if row > 0 and column > 0 and row <= self.tileMap.height and column <= self.tileMap.width then
                local cell = self.cells[row][column]
                for _, tile in ipairs(cell) do
                    if tile.value ~= -1 then
                        table.insert(tilesInRectangle, tile)
                    end
                end
            end
        end
    end
    return tilesInRectangle
end

return TileMapLayer
