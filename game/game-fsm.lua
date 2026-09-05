local FSM            = require("core.fsm")
local FSMState       = require("core.fsm-state")
local DialogueState  = require("game.states.dialogue-state")
local InventoryState = require("game.states.inventory-state")
local Player         = require("game.entities.player")
local Portal         = require("game.entities.portal")
local Item           = require("game.entities.base.item")
local Npc            = require("game.entities.base.npc")

---@class GameFSM: FSM
---@field context World
---@field playState FSMState
---@field dialogueState DialogueState
---@field inventoryState InventoryState
local GameFSM        = {}
GameFSM.__index      = GameFSM
setmetatable(GameFSM, FSM)

---@param world World
---@return GameFSM
function GameFSM:new(world)
    local t = setmetatable(FSM:new({}), self)
    ---@cast t GameFSM
    t.context = world
    t.playState = FSMState:new(t.context)
    t.playState.update = t.playStateUpdate
    t.dialogueState = DialogueState:new(t.context)
    t.inventoryState = InventoryState:new(t.context)

    t:gotoState(t.playState)

    return t
end

function GameFSM:playStateUpdate()
    local world = self.context
    if Buttons.save.justPressed then
        world:save()
    end
    if Buttons.load.justPressed then
        world:load()
    end

    world.entityManager:update()
    if Buttons.inventory.justPressed then
        world.fsm:gotoState(world.fsm.inventoryState)
    end

    local player = world.entityManager:getFirst(Player)
    if player then
        if Buttons.action.justPressed then
            local npc = world.entityManager:getClosestOverlapping(player, Npc)
            if npc then world.fsm:gotoState(world.fsm.dialogueState, npc.dialogue()) end

            local portal = world.entityManager:getClosestOverlapping(player, Portal)
            if portal then world.fsm.context:travel(portal.target) end

            local item = world.fsm.context.entityManager:getClosestOverlapping(player, Item)
            if item then world.fsm.context:pickUp(item) end
        end
    end
end

function GameFSM:draw()
    if self.currentState.draw then
        self.currentState:draw()
    end
end

return GameFSM
