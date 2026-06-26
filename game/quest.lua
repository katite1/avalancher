---@class Quest
---@field completed boolean
---@
local Quest = {}
Quest.__index = Quest

function Quest:new()
    local t = setmetatable({}, self)
    return t
end

return Quest
