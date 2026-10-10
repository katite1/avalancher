local FSMState         = require("core.fsm-state")

---@class InventoryState: FSMState
local InventoryState   = {}
InventoryState.__index = InventoryState
setmetatable(InventoryState, FSMState)

---@param world World
function InventoryState.update(world)
    if Buttons.inventory.justPressed then
        world.fsm:gotoState(world.fsm.previousState)
    end
end

---@param world World
function InventoryState.draw(world)
    world.inventory:draw()
end

return InventoryState
