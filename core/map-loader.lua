local json = require("lib.json")

---@class TileMap
---@field width number
---@field height number
---@field cellSize number
---@field tiles number[][]
local TileMap = {}

---@param width number
---@param height number
---@param cellSize number
---@return TileMap
function TileMap:new(width, height, cellSize)
    local t = setmetatable({}, { __index = self })
    t.width = width
    t.height = height
    t.cellSize = cellSize
    t.tiles = {}
    for i = 1, height, 1 do
        table.insert(t.tiles, {})
        for j = 1, width, 1 do
            table.insert(t.tiles[i], 0)
        end
    end
    return t
end

function TileMap:draw()
    local tileset = love.graphics.newImage("assets/test-tileset/world_tileset.png")
    local width, height = tileset:getDimensions()
    width = math.floor(width / self.cellSize)
    height = math.floor(height / self.cellSize - 1)
    for y, row in ipairs(self.tiles) do
        for x, cellValue in ipairs(row) do
            if cellValue ~= 0 then
                local tileX = (cellValue - 1) % width + 1
                local tileY = math.floor((cellValue - 1) / height) + 1
                local quad = love.graphics.newQuad(
                    tileX * self.cellSize - self.cellSize, tileY * self.cellSize - self.cellSize,
                    self.cellSize, self.cellSize,
                    tileset
                )
                love.graphics.draw(tileset, quad, x * self.cellSize, y * self.cellSize)
            end
        end
    end
end

---@class MapLoader
local MapLoader = {}

---@param str string
---@return TileMap | false
function MapLoader:load(str)
    local map = json.decode(love.filesystem.read(str))
    if map.layers then
        local layer = map.layers[1]
        local width = layer.width
        local height = layer.height
        local cellCount = width * height
        local cellSize = map.tilewidth
        local tileMap = TileMap:new(width, height, cellSize)
        for cellIndex = 1, cellCount, 1 do
            local cell = layer.data[cellIndex]
            local x = (cellIndex - 1) % width + 1
            local y = math.floor((cellIndex - 1) / height) + 1
            tileMap.tiles[y][x] = cell
        end
        return tileMap
    end
    return false
end

return MapLoader
