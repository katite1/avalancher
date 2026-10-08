local FSMState = require("core.fsm-state")

---@class PatrolWaitState : FSMState
local PatrolWaitState = setmetatable({}, { __index = FSMState })
PatrolWaitState.__index = PatrolWaitState

function PatrolWaitState:enter()
    local mushroom = self.context
    ---@cast mushroom Mushroom

    mushroom.sprite = mushroom.idleSprite

    mushroom.timers.jump:restart()
    mushroom.timers.wait:restart()
end

function PatrolWaitState:exit()
    local mushroom = self.context
    ---@cast mushroom Mushroom
    mushroom.timers.jump:stop()
    mushroom.timers.wait:stop()
    mushroom.sprite = mushroom.patrolSprite
    return true
end

return PatrolWaitState
