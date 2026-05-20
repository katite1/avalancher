---@class TiledHelper
local TiledHelper = {}

---Returns whether the property table has this entry in the value field
---@param properties table properties table from tiled
---@param property string
---@return boolean
function TiledHelper.hasProperty(properties, property)
    for _, propertyItem in ipairs(properties) do
        for value, _ in pairs(propertyItem.value) do
            if value == property then
                return true
            end
        end
    end
    return false
end

return TiledHelper
