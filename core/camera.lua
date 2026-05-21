---@class Camera
---@field x integer
---@field y integer
local Camera = {}
Camera.__index = Camera

---@return Camera
function Camera:new()
    local t = setmetatable({}, { __index = self })
    t.x = 0
    t.y = 0
    return t
end

function Camera:drawStart()
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
end

function Camera:drawEnd()
    love.graphics.pop()
end

return Camera
