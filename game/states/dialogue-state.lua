local FSMState        = require("core.fsm-state")
local Panel           = require("game.ui.panel")

---@class DialogueState: FSMState
---@field world World
---@field progress integer
---@field previousState FSMState
---@field dialoguePanel Panel
local DialogueState   = {}
DialogueState.__index = DialogueState
setmetatable(DialogueState, FSMState)

---@param world World
---@return DialogueState
function DialogueState:new(world)
    local t = setmetatable(FSMState:new(), self)
    t.progress = 1
    t.world = world
    t.dialoguePanel = Panel:new(SPRITES.PANEL, 8)
    ---@cast t DialogueState

    return t
end

---@param previousState FSMState
---@param dialogue Dialogue
function DialogueState:enter(previousState, dialogue)
    self.previousState = previousState
    self.dialogue = dialogue
end

function DialogueState:update()
    if Buttons.down.justPressed then
        if (self.progress == #self.dialogue) then
            self.world.fsm:gotoState(self.previousState)
            return
        end
        self.progress = self.progress + 1
    end
end

function DialogueState:draw()
    self.dialoguePanel:draw(SCREEN.WIDTH, 48)
    love.graphics.printf(
        self.dialogue[self.progress],
        8, 8, SCREEN.WIDTH - 16
    )
end

function DialogueState:exit()
    self.progress = 1
    self.dialogue = nil
    return true
end

return DialogueState
