---@class Element
local Element = {}
Element.__index = Element

function Element:new()
    local t = setmetatable({}, self)
    return t
end

return Element
