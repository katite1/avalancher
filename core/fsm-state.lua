---@class FSMState
---@field context table
---@field update fun(self: FSMState) | nil
---@field draw fun(self: FSMState) | nil
---@field enter fun(self: FSMState, previousState: FSMState | nil, ...) | nil
---@field exit (fun(self: FSMState, nextState: FSMState) : boolean) | nil
local FSMState = {}

FSMState.__index = FSMState

---@param context table
---@return FSMState
function FSMState:new(context)
    local t = setmetatable({}, self)
    t.context = context
    return t
end

return FSMState
