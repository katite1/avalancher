local Timer = require("core.timer")

---@class PatrolWaitState : FSMState
local patrolWaitState = {}
function patrolWaitState:enter()
    local mushroom = self.context
    ---@cast mushroom Mushroom

    self.jumpTimer = Timer:new(50, function()
        mushroom:jump()
    end)
    self.waitTimer = Timer:new(100, function()
        mushroom.fsm:gotoState(mushroom.patrolState)
    end)
end

function patrolWaitState:update()
    self.waitTimer:update()
    self.jumpTimer:update()
end

function patrolWaitState:exit()
    self.waitTimer:stop()
    self.jumpTimer:stop()
    return true
end

return patrolWaitState
