local FSM            = require("core.fsm")
local DialogueState  = require("game.states.dialogue-state")
local InventoryState = require("game.states.inventory-state")
local PlayState      = require("game.states.play-state")

---@class GameFSM: FSM
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
    t.playState = PlayState
    t.dialogueState = DialogueState
    t.inventoryState = InventoryState
    t:registerState(t.playState, "play")
    t:registerState(t.dialogueState, "dialogue")
    t:registerState(t.inventoryState, "inventory")
    t:gotoState(t.playState)

    return t
end

function GameFSM:draw()
    if self.currentState.draw then
        self.currentState.draw(self.context)
    end
end

return GameFSM
