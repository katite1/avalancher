local Timer = require("core.timer")

---@class stompedState : FSMState
local stompedState = {}
function stompedState:enter(previousState)
    local mushroom = self.context
    ---@cast mushroom Mushroom

    mushroom.sprite = mushroom.stompedSprite
    if previousState then
        self.unstompTimer = Timer:new(120, function()
            mushroom.fsm:gotoState(previousState)
        end)
    end
end

function stompedState:update()
    self.unstompTimer:update()
end

function stompedState:exit()
    ---@type Mushroom
    local mushroom = self.context
    mushroom.sprite = mushroom.patrolSprite

    self.unstompTimer:stop()
    return true
end

return stompedState
