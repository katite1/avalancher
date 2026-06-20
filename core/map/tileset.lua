---@class Tileset
---@field image love.Image
---@field quads love.Quad[]
local Tileset = {}
Tileset.__index = Tileset

---@param image love.Image
---@return Tileset
function Tileset:new(image)
    local t = setmetatable({}, self)
    t.image = image
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

return Tileset
