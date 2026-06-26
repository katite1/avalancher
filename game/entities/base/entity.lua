---@alias BoundingBox {x: number, y: number, w: number, h: number}

---@class Entity
---@field world World
---@field x number
---@field y number
---@field w number
---@field h number
---@field bb BoundingBox
---@field update function
---@field dialogueReference string | nil
---@field deserializeLdtk nil | fun(data): Entity
---@field draw function | nil
local Entity = {}
Entity.__index = Entity

function Entity:new()
    local t = setmetatable({}, self)
    t.x = 0
    t.y = 0
    t.w = 16
    t.h = 16
    t.bb = { x = t.x, y = t.y, w = t.w, h = t.h }
    t.world = nil
    return t
end

function Entity:update()
end

return Entity
