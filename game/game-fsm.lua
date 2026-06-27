local FSM            = require("core.fsm")
local FSMState       = require("core.fsm-state")
local DialogueState  = require("game.states.dialogue-state")
local InventoryState = require("game.states.inventory-state")
local Player         = require("game.entities.player")
local Sign           = require("game.entities.sign")
local Portal         = require("game.entities.portal")
local Item           = require("game.entities.item")

---@class GameFSM: FSM
---@field world World
---@field playState FSMState
---@field dialogueState DialogueState
---@field inventoryState InventoryState
local GameFSM        = {}
GameFSM.__index      = GameFSM
setmetatable(GameFSM, FSM)

---@param world World
---@return GameFSM
function GameFSM:new(world)
    local t = setmetatable(FSM:new(), self)
    ---@cast t GameFSM
    t.world = world
    t.playState = FSMState:new()
    t.dialogueState = DialogueState:new(t.world)
    t.inventoryState = InventoryState:new(t.world)

    function t.playState:update()
        t.world.entityManager:update()
        if Buttons.inventory.justPressed then
            t:gotoState(t.inventoryState)
        end

        local player = t.world.entityManager:getFirst(Player)
        if player then
            local sign = t.world.entityManager:getClosest(player.x, player.y, Sign)
            if sign then
                if t.world.collisionManager:areOverlapping(player, sign) then
                    if Buttons.action.justPressed then
                        t:gotoState(t.dialogueState, DialogueItems[sign.dialogueReference])
                    end
                end
            end
            local portal = t.world.entityManager:getClosest(player.x, player.y, Portal)
            if portal then
                if t.world.collisionManager:areOverlapping(player, portal) then
                    if Buttons.action.justPressed then
                        t.world:travel(portal.target)
                    end
                end
            end
            local item = t.world.entityManager:getClosest(player.x, player.y, Item)
            if item then
                if t.world.collisionManager:areOverlapping(player, item) then
                    if Buttons.action.justPressed then
                        t.world:pickUp(item)
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
