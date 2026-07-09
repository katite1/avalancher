---@class Tile
---@field x integer
---@field y integer
---@field width integer
---@field height integer
---@field value integer
---@field offsetX integer
---@field offsetY integer
---@field flipX boolean
---@field flipY boolean
local Tile = {}
Tile.__index = Tile

---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param value integer
---@param offsetX integer | nil
---@param offsetY integer | nil
---@return Tile
function Tile:new(x, y, width, height, value, offsetX, offsetY)
    local t = setmetatable({}, { __index = self })
    t.x = x
    t.y = y
    t.width = width
    t.height = height
    t.value = value
    t.offsetX = offsetX or 0
    t.offsetY = offsetY or 0
    return t
end

---@class SerializedTile
---@field x integer
---@field y integer
---@field width integer
---@field height integer
---@field value integer
---@field offsetX integer
---@field offsetY integer
---@field flipX boolean
---@field flipY boolean

---@return SerializedTile
function Tile:serialize()
    local tile = {}

    tile.x = self.x
    tile.y = self.y
    tile.width = self.width
    tile.height = self.height
    tile.value = self.value
    tile.offsetX = self.offsetX
    tile.offsetY = self.offsetY
    tile.flipX = self.flipX
    tile.flipY = self.flipY

    return tile
end

---@param serializedTile SerializedTile
---@return Tile
function Tile.deserialize(serializedTile)
    local tile = Tile:new(
        serializedTile.x,
        serializedTile.y,
        serializedTile.width,
        serializedTile.height,
        serializedTile.value,
        serializedTile.offsetX,
        serializedTile.offsetY
    )
    tile.flipX = serializedTile.flipX
    tile.flipY = serializedTile.flipY
    return tile
end

return Tile
