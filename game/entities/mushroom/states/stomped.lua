local FSMState = require("core.fsm-state")
local Timer = require("core.timer")

---@class StompedState : FSMState
local StompedState = setmetatable({}, { __index = FSMState })
StompedState.__index = StompedState

---@param mushroom Mushroom
function StompedState.enter(mushroom, previousState)
    ---@cast mushroom Mushroom
    mushroom.sprite = mushroom.stompedSprite
    if previousState then
        mushroom.timers.unstomp = Timer:new(120, function()
            mushroom.fsm:gotoState(previousState)
        end)
    end
end

---@param mushroom Mushroom
function StompedState.exit(mushroom)
    mushroom.sprite = mushroom.patrolSprite

    mushroom.timers.unstomp:stop()
    return true
end

return StompedState
