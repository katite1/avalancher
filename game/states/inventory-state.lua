local FSMState         = require("core.fsm-state")

---@class InventoryState: FSMState
---@field previousState FSMState
local InventoryState   = {}
InventoryState.__index = InventoryState
setmetatable(InventoryState, FSMState)

---@param world World
---@return InventoryState
function InventoryState:new(world)
    local t = setmetatable(FSMState:new(), self)
    t.context = world
    ---@cast t InventoryState

    return t
end

---@param previousState FSMState
function InventoryState:enter(previousState)
    self.previousState = previousState
end

function InventoryState:update()
    if Buttons.inventory.justPressed then
        self.context.fsm:gotoState(self.previousState)
    end
end

function InventoryState:draw()
    self.context.inventory:draw()
end

return InventoryState
