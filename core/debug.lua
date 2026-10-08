---@class Debug
---@field stack any[]
---@field drawY integer
---@field targetX number
---@field targetY number
local Debug = {}
Debug.__index = Debug

function Debug:new()
    local t = setmetatable({}, self)
    ---@cast t Debug
    t.stack = {}
    t.drawY = 0
    t.targetX = 0
    t.targetY = 0
    return t
end

---@param item any
---@param depth integer | nil
function Debug:write(item, depth)
    table.insert(self.stack, Inspect(item, { depth = depth or 2 }))
end

function Debug:clear()
    self.stack = {}
    self.targetX = 0
    self.targetY = 0
end

function Debug:breakpoint()
    TICK.rate = 0
end

---@param x number
---@param y number
function Debug:at(x, y)
    self.targetX = x
    self.targetY = y
end

---@param scale integer
function Debug:draw(scale)
    love.graphics.push()
    love.graphics.scale(scale)
    if Buttons.debugScrollDown.pressed then
        self.drawY = math.min(self.drawY + 10, 0)
    end
    if Buttons.debugScrollUp.pressed then
        self.drawY = self.drawY - 10
    end

    local x = self.targetX
    local y = self.drawY + self.targetY
    for i, item in ipairs(self.stack) do
        local text = love.graphics.newText(love.graphics:getFont(), item)
        local height = text:getHeight()
        love.graphics.print(item, x, y)
        y = y + height
    end
    love.graphics.pop()
end

return Debug
