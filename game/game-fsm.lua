local FSM           = require("core.fsm")
local FSMState      = require("core.fsm-state")
local DialogueState = require("game.dialogue-state")
local Player        = require("game.player")
local Sign          = require("game.sign")
local Portal        = require("game.portal")

---@class GameFSM: FSM
---@field world World
---@field playState FSMState
---@field dialogueState DialogueState
local GameFSM       = {}
GameFSM.__index     = GameFSM
setmetatable(GameFSM, FSM)

---@param world World
---@return GameFSM
function GameFSM:new(world)
    local t = setmetatable(FSM:new(), self)
    ---@cast t GameFSM
    t.world = world
    t.playState = FSMState:new()
    t.dialogueState = DialogueState:new(t.world)

    function t.playState:update()
        t.world.entityManager:update()
        local player = t.world.entityManager:getFirst(Player)
        if player then
            local sign = t.world.entityManager:getClosest(player.x, player.y, Sign)
            if sign then
                if t.world.collisionManager:areOverlapping(player, sign) then
                    if Buttons.talk.justPressed then
                        t:gotoState(t.dialogueState, DialogueItems[sign.dialogueReference])
                    end
                end
            end
            local portal = t.world.entityManager:getClosest(player.x, player.y, Portal)
            if portal then
                if t.world.collisionManager:areOverlapping(player, portal) then
                    if Buttons.talk.justPressed then
                        t.world:travel(portal.target)
                    end
                end
            end
        end
    end

    t:gotoState(t.playState)

    return t
end

function GameFSM:draw()
    if self.currentState.draw then
        self.currentState:draw()
    end
end

return GameFSM
