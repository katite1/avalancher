---@class FSM
---@field currentState FSMState
---@field queuedState FSMState
---@field queuedStateArgs any
local FSM = {}

FSM.__index = FSM

---@return FSM
function FSM:new()
    local t = setmetatable({}, self)
    return t
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
        error("you forgot to use gotoState for an fsm!!!")
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
