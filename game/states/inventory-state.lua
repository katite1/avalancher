local FSMState         = require("core.fsm-state")
local Panel            = require("game.ui.panel")

---@class InventoryState: FSMState
---@field world World
---@field previousState FSMState
local InventoryState   = {}
InventoryState.__index = InventoryState
setmetatable(InventoryState, FSMState)

---@param world World
---@return InventoryState
function InventoryState:new(world)
    local t = setmetatable(FSMState:new(), self)
    t.progress = 1
    t.world = world
    ---@cast t InventoryState

    return t
end

---@param previousState FSMState
function InventoryState:enter(previousState)
    self.previousState = previousState
end

function InventoryState:update()
    if Buttons.inventory.justPressed then
        self.world.fsm:gotoState(self.previousState)
    end
end

function InventoryState:draw()
    self.world.inventory:draw()
end

return InventoryState
