---@class PatrolState : FSMState
local patrolState = {}
function patrolState:update()
    local mushroom = self.context
    ---@cast mushroom Mushroom
    if mushroom.x > mushroom.target.x then
        mushroom:walkLeft()
    end
    if mushroom.x < mushroom.target.x then
        mushroom:walkRight()
    end

    if math.abs(mushroom.x - mushroom.target.x) < 4 then
        if mushroom.target.x == mushroom.patrolStart.x then
            mushroom.target = mushroom.patrolEnd
        else
            mushroom.target = mushroom.patrolStart
        end

        mushroom.fsm:gotoState(mushroom.patrolWaitState)
    end
end

return patrolState
