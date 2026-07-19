---@class Debug
---@field stack any[]
local Debug = {}
Debug.__index = Debug

function Debug:new()
    local t = setmetatable({}, self)
    ---@cast t Debug
    t.stack = {}
    return t
end

---@param item any
---@param depth integer | nil
function Debug:write(item, depth)
    table.insert(self.stack, Inspect(item, { depth = depth or 2 }))
end

function Debug:clear()
    self.stack = {}
end

function Debug:breakpoint()
    TICK.rate = 0
end

---@param scale integer
function Debug:draw(scale)
    love.graphics.push()
    love.graphics.scale(scale)
    local y = 0
    for i, item in ipairs(self.stack) do
        local text = love.graphics.newText(love.graphics:getFont(), item)
        local height = text:getHeight()
        love.graphics.print(item, 0, y)
        y = y + height
    end
    love.graphics.pop()
end

return Debug
