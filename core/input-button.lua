---@class InputButton
---@field keys string[]
---@field lastState boolean
---@field justPressed boolean
---@field pressed boolean
---@field justReleased boolean
---@field released boolean
local InputButton = {}

---@param keys string[]
---@return InputButton
function InputButton:new(keys)
    local t = setmetatable({}, { __index = self })
    t.keys = keys
    return t
end

return InputButton
