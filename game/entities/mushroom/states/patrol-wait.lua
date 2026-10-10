local FSMState = require("core.fsm-state")

---@class PatrolWaitState : FSMState
local PatrolWaitState = setmetatable({}, { __index = FSMState })
PatrolWaitState.__index = PatrolWaitState

---@param mushroom Mushroom
function PatrolWaitState.enter(mushroom)
    mushroom.sprite = mushroom.idleSprite

    mushroom.timers.jump:restart()
    mushroom.timers.wait:restart()
end

---@param mushroom Mushroom
function PatrolWaitState.exit(mushroom)
    ---@cast mushroom Mushroom
    mushroom.timers.jump:stop()
    mushroom.timers.wait:stop()
    mushroom.sprite = mushroom.patrolSprite
    return true
end

return PatrolWaitState
