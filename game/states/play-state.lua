local FSMState    = require("core.fsm-state")
local Player      = require("game.entities.player")
local Portal      = require("game.entities.portal")
local Item        = require("game.entities.base.item")
local Npc         = require("game.entities.base.npc")

---@class PlayState: FSMState
local PlayState   = {}
PlayState.__index = PlayState
setmetatable(PlayState, FSMState)

---@param world World
function PlayState.update(world)
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

return PlayState
