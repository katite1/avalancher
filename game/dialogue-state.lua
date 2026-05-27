local FSMState        = require("core.fsm-state")

---@class DialogueState: FSMState
---@field world World
---@field progress integer
---@field previousState FSMState
local DialogueState   = {}
DialogueState.__index = DialogueState
setmetatable(DialogueState, FSMState)

---@param world World
---@return DialogueState
function DialogueState:new(world)
    local t = setmetatable(FSMState:new(), self)
    t.progress = 0
    t.world = world
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
        self.progress = self.progress + 1
        print(self.dialogue.steps[self.progress])
        if (self.progress == #self.dialogue.steps) then
            self.world.fsm:gotoState(self.previousState)
            return
        end
    end
end

function DialogueState:exit()
    self.progress = 0
    self.dialogue = nil
    return true
end

return DialogueState
