---@class Tileset
---@field imageDirectory string
---@field imageFilename string
---@field image love.Image
---@field quads love.Quad[]
local Tileset = {}
Tileset.__index = Tileset

---@class SerializedTileset
---@field imageDirectory string
---@field imageFilename string

---@param directory string
---@param filename string
---@return Tileset
function Tileset:new(directory, filename)
    local t = setmetatable({}, self)
    t.imageDirectory = directory
    t.imageFilename = filename
    t.image = love.graphics.newImage(directory .. filename)
    t.quads = t:makeQuads()
    return t
end

---@return love.Quad[]
function Tileset:makeQuads()
    local quads = {}
    local width = math.floor(self.image:getWidth() / 16) -- TODO: make tile size global probably
    local height = math.floor(self.image:getHeight() / 16)
    for i = 0, height - 1 do
        for j = 0, width - 1 do
            table.insert(quads,
                love.graphics.newQuad(j * 16, i * 16, 16, 16, self.image)
            )
        end
    end
    return quads
end

---@return SerializedTileset
function Tileset:serialize()
    ---@type SerializedTileset
    return {
        imageDirectory = self.imageDirectory,
        imageFilename = self.imageFilename,
    }
end

---@param data SerializedTileset
function Tileset.deserialize(data)
    return Tileset:new(data.imageDirectory, data.imageFilename)
end

return Tileset
