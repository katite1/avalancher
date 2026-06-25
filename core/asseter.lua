---@class Asseter
---@field path string
local Asseter = {}
Asseter.__index = Asseter

---@param path string
---@return Asseter
function Asseter:new(path)
    local t = setmetatable({}, self)
    t.path = path
    return t
end

---@param asset string
---@param wrap boolean | nil
function Asseter:load(asset, wrap)
    local image = love.graphics.newImage(self.path .. asset)
    if wrap then
        image:setWrap('repeat', 'repeat')
    end
    return image
end

return Asseter
