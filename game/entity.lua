---@class Entity
---@field x number
---@field y number
---@field update function
---@field draw function | nil
local Entity = {}

function Entity:new()
    local t = setmetatable({}, { __index = self })
    t.x = 0
    t.y = 0
    return t
end

return Entity
