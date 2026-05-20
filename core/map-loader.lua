local json = require("lib.json")

---@class Tile
---@field x integer
---@field y integer
---@field value integer
local Tile = {}
function Tile:new(x, y, value)
    local t = setmetatable({}, { __index = self })
    t.x = x
    t.y = y
    t.value = value
    return t
end

---@class TileMap
---@field x number
---@field y number
---@field width number
---@field height number
---@field tileSize number
---@field tiles number[][]
---@field tileset love.Image
---@field tileProperties [number, string[]]
---@field tint [number, number, number]
local TileMap = {}

---@param width number
---@param height number
---@param tileSize number
---@param tileset love.Image
---@param tint [number, number, number] | nil
---@return TileMap
function TileMap:new(width, height, tileSize, tileset, tint)
    local t = setmetatable({}, { __index = self })
    t.x = 0
    t.y = 0
    t.width = width
    t.height = height
    t.tileSize = tileSize
    t.tiles = {}
    t.tileProperties = {}
    t.tileset = tileset
    t.tint = tint or { 0, 0, 0 }
    for i = 1, height, 1 do
        table.insert(t.tiles, {})
        for j = 1, width, 1 do
            table.insert(t.tiles[i], 0)
        end
    end
    return t
end

function TileMap:draw()
    love.graphics.push("all")
    love.graphics.setColor(self.tint)
    local width, height = self.tileset:getDimensions()
    width = math.floor(width / self.tileSize)
    height = math.floor(height / self.tileSize - 1)
    for y, row in ipairs(self.tiles) do
        for x, tileValue in ipairs(row) do
            if tileValue ~= 0 then
                local tileX = (tileValue - 1) % width + 1
                local tileY = math.floor((tileValue - 1) / height) + 1
                local quad = love.graphics.newQuad(
                    tileX * self.tileSize - self.tileSize, tileY * self.tileSize - self.tileSize,
                    self.tileSize, self.tileSize,
                    self.tileset
                )
                love.graphics.draw(self.tileset, quad, x * self.tileSize, y * self.tileSize)
            end
        end
    end
    love.graphics.pop()
end

---@return Tile[]
function TileMap:getTilesInRectangle(x, y, w, h)
    local theTiles = {}
    local relativeX = math.floor((x - self.x) / self.tileSize)
    local relativeY = math.floor((y - self.y) / self.tileSize)
    local xCellCount = math.floor(w / self.tileSize)
    local yCellCount = math.floor(h / self.tileSize)
    for row = relativeY, yCellCount + relativeY, 1 do
        for column = relativeX, xCellCount + relativeX, 1 do
            if row > 0 and column > 0 and row <= self.height and column <= self.width then
                local value = self.tiles[row][column]
                if value ~= 0 and self.tileProperties[value] == "solid" then
                    love.graphics.rectangle("fill", column * self.tileSize, row * self.tileSize, self.tileSize, self
                        .tileSize)
                    table.insert(theTiles, Tile:new(row, column, value))
                end
            end
        end
    end
    return theTiles
end

---@class MapLoader
---@field directory string
---@field map table | nil
---@field tileset love.Image
local MapLoader = {}

function MapLoader:new(directory, tileset)
    local t = setmetatable({}, { __index = self })
    t.directory = directory
    t.tileset = tileset
    return t
end

---@param mapName string
---@return TileMap | false
function MapLoader:load(mapName)
    self.map = json.decode(love.filesystem.read(self.directory .. mapName))
    if self.map.layers then
        local layer = self.map.layers[1]
        local width = layer.width
        local height = layer.height
        local tileCount = width * height
        local tileSize = self.map.tilewidth
        local tileMap = TileMap:new(
            width, height, tileSize,
            self.tileset
        )
        for tileIndex = 1, tileCount, 1 do
            local tile = layer.data[tileIndex]
            local x = (tileIndex - 1) % width + 1
            local y = math.floor((tileIndex - 1) / height) + 1
            tileMap.tiles[y][x] = tile
        end
        for _, tile in ipairs(self.map.tileset.tiles) do
            table.insert(
                tileMap.tileProperties,
                tile.id + 1,
                tile.type
            )
        end
        return tileMap
    end
    return false
end

function MapLoader:loadLayer(layer)
    local width = layer.width
    local height = layer.height
    local tileCount = width * height
    local tileSize = layer.tilewidth
    local tileMap = TileMap:new(
        width, height, tileSize,
        self.tileset
    )
    for tileIndex = 1, tileCount, 1 do
        local tile = layer.data[tileIndex]
        local x = (tileIndex - 1) % width + 1
        local y = math.floor((tileIndex - 1) / height) + 1
        tileMap.tiles[y][x] = tile
    end
    for _, tile in ipairs(self.map.tileset.tiles) do
        table.insert(
            tileMap.tileProperties,
            tile.id + 1,
            tile.type
        )
    end
    return tileMap
end

---@layer table
function MapLoader:loadBackground(layer, tileset)
    local width = layer.width
    local height = layer.height
    local tileset = tileset -- one tileset for now
    local tileCount = width * height
    local tileSize = layer.tilewidth
    local tileMap = TileMap:new(
        width, height, tileSize,
        love.graphics.newImage(self.directory .. tileset.image),
        { 0.5, 0.5, 0.5 }
    )
    for tileIndex = 1, tileCount, 1 do
        local tile = layer.data[tileIndex]
        local x = (tileIndex - 1) % width + 1
        local y = math.floor((tileIndex - 1) / height) + 1
        tileMap.tiles[y][x] = tile
    end
    for _, tile in ipairs(tileset.tiles) do
        table.insert(
            tileMap.tileProperties,
            tile.id + 1,
            tile.type
        )
    end
    return tileMap
end

return MapLoader
