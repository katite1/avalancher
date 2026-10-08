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
    love.graphics.translate(math.floor(-self.x), math.floor(-self.y))
end

-- ---@param x number
-- ---@param y number
-- ---@return number, number
-- --- untested, probably doesn't work
-- function Camera:screenToWorldPosition(x, y)
--     return math.floor(x - self.x + SCREEN.WIDTH / 2), math.floor(y - self.y + SCREEN.HEIGHT / 2)
-- end

-- ---@param x number
-- ---@param y number
-- ---@return number, number
-- function Camera:worldToScreenPosition(x, y)
--     return x, y
-- end

function Camera:drawEnd()
    love.graphics.pop()
end

return Camera
