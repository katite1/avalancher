---@class ProgressionEntry
---@field progress integer | boolean
---@field finalProgressValue integer | nil
local ProgressionEntry = {}
ProgressionEntry.__index = ProgressionEntry

---@alias SerializedProgressionEntry ProgressionEntry

---@param progress integer | boolean
---@param finalProgressValue integer | nil
---@return ProgressionEntry
function ProgressionEntry:new(progress, finalProgressValue)
    local t = setmetatable({}, self)
    t.progress = progress
    t.finalProgressValue = finalProgressValue
    return t
end

---@return SerializedProgressionEntry
function ProgressionEntry:serialize()
    return { progress = self.progress, finalProgressValue = self.finalProgressValue }
end

---@param entryData SerializedProgressionEntry
function ProgressionEntry.deserialize(entryData)
    return ProgressionEntry:new(entryData.progress, entryData.finalProgressValue)
end

---@return boolean
function ProgressionEntry:isCompleted()
    if type(self.progress) == "boolean" then
        ---@type boolean
        return self.progress
    elseif self.progress >= self.finalProgressValue then
        return true
    end
    return false
end

return ProgressionEntry
