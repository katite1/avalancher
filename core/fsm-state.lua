---@class FSMState
---@field update fun(context: any) | nil
---@field draw fun(context: any) | nil
---@field enter fun(context, previousState: FSMState | nil, ...) | nil
---@field exit (fun(context, nextState: FSMState) : boolean) | nil
local FSMState = {}
FSMState.__index = FSMState

return FSMState
