local ProgressionEntry = require("game.progression-entry")

---@class ProgressionEntries
---@field bunny ProgressionEntry
local ProgressionEntries = {}
ProgressionEntries.__index = ProgressionEntries

ProgressionEntries.bunny = ProgressionEntry:new(false)

return ProgressionEntries
