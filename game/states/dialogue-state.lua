local FSMState        = require("core.fsm-state")
local Panel           = require("game.ui.panel")

---@class DialogueState: FSMState
---@field progress integer
---@field previousState FSMState
---@field dialoguePanel Panel
local DialogueState   = {}
DialogueState.__index = DialogueState
setmetatable(DialogueState, FSMState)
DialogueState.panel = Panel:new(IMAGES.SPRITES.PANEL, 8)

---@param world World
---@param dialogue Dialogue
function DialogueState.enter(world, _, dialogue)
    world.dialogueProgress.dialogue = dialogue
    world.dialogueProgress.progress = 1
end

---@param world World
function DialogueState.update(world)
    if Buttons.down.justPressed then
        if (world.dialogueProgress.progress == #world.dialogueProgress.dialogue) then
            world.fsm:gotoState(world.fsm.previousState)
            return
        end
        world.dialogueProgress.progress = world.dialogueProgress.progress + 1
    end
end

---@param world World
function DialogueState.draw(world)
    DialogueState.panel:draw(SCREEN.WIDTH, 48)
    love.graphics.printf(
        world.dialogueProgress.dialogue[world.dialogueProgress.progress],
        8, 8, SCREEN.WIDTH - 16
    )
end

---@param world World
function DialogueState.exit(world)
    world.dialogueProgress.progress = 0
    world.dialogueProgress.dialogue = nil
    return true
end

return DialogueState
