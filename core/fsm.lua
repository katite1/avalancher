---@class FSM
---@field context table
---@field registeredStates {[string]: FSMState}
---@field currentState FSMState
---@field queuedState FSMState
---@field queuedStateArgs any
local FSM = {}
FSM.__index = FSM

---@class SerializedFSM
---@field currentState string | nil
---@field queuedState string | nil

---@return FSM
---@param context table
function FSM:new(context)
    local t = setmetatable({}, self)
    t.context = context
    t.registeredStates = {}
    return t
end

---@param state FSMState
function FSM:registerState(state, name)
    self.registeredStates[name] = state
end

function FSM:getCurrentStateName()
    for name, state in pairs(self.registeredStates) do
        if state == self.currentState then
            return name
        end
    end
    return ""
end

---@return SerializedFSM
function FSM:serialize()
    local currentStateName = nil
    local queuedStateName = nil
    for name, state in pairs(self.registeredStates) do
        if state == self.currentState then
            currentStateName = name
        end
        if state == self.queuedState then
            queuedStateName = name
        end
    end
    ---@type SerializedFSM
    return {
        currentState = currentStateName,
        queuedState = queuedStateName,
    }
end

---@param state FSMState
---@param ... any
function FSM:gotoState(state, ...)
    if self.currentState == nil then
        self.currentState = state
        if self.currentState.enter then
            self.currentState:enter(nil, ...)
        end
        return
    end
    self.queuedState = state
    self.queuedStateArgs = ...
end

function FSM:update()
    if self.currentState == nil then
        return
    end
    if self.queuedState == nil then
        if self.currentState.update then
            self.currentState:update()
        end
        return
    end
    if self.currentState.exit then
        if self.currentState:exit(self.queuedState) then
            local previousState = self.currentState
            if self.queuedState.enter then
                self.queuedState:enter(previousState, self.queuedStateArgs)
            end
            self.currentState = self.queuedState
            self.queuedState = nil
        end
    else
        local previousState = self.currentState
        if self.queuedState.enter then
            self.queuedState:enter(previousState, self.queuedStateArgs)
        end
        self.currentState = self.queuedState
        self.queuedState = nil
    end
end

return FSM
