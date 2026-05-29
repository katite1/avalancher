---@class FSMState
---@field update fun(self: FSMState) | nil
---@field draw fun(self: FSMState) | nil
---@field enter fun(self: FSMState, previousState: FSMState | nil, ...) | nil
---@field exit (fun(self: FSMState, nextState: FSMState) : boolean) | nil
local FSMState = {}

FSMState.__index = FSMState

---@return FSMState
function FSMState:new()
    local t = setmetatable({}, self)
    return t
end

return FSMState
