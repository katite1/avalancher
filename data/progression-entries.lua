local ProgressionEntry = require("game.progression-entry")

---@class ProgressionEntries
---@field bunny ProgressionEntry
local ProgressionEntries = {}
ProgressionEntries.__index = ProgressionEntries
ProgressionEntries.entry = {}
ProgressionEntries.entry.bunny = ProgressionEntry:new(false)

---@return table
function ProgressionEntries:serialize()
    local entries = {}
    for entryName, entry in pairs(ProgressionEntries.entry) do
        entries[entryName] = entry:serialize()
    end
    return entries
end

---@param entries {progress: integer | boolean, finalProgressValue: integer | nil}[]
---@return ProgressionEntries
function ProgressionEntries.deserialize(entries)
    for entryName, entryData in pairs(entries) do
        ProgressionEntries.entry[entryName] = ProgressionEntry.deserialize(entryData)
    end
    return ProgressionEntries
end

return ProgressionEntries
