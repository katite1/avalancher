---@class TiledHelper
local TiledHelper = {}
TiledHelper.__index = TiledHelper

---Returns whether the property table has this entry in the value field
---@param properties table properties table from tiled
---@param propertyType string
---@param propertyValue string
---@return boolean
function TiledHelper.hasPropertyValue(properties, propertyType, propertyValue)
    for _, property in ipairs(properties) do
        if property.propertytype == propertyType then
            for value, _ in pairs(property.value) do
                if value == propertyValue then
                    return true
                end
            end
        end
    end
    return false
end

---Returns first property value from property type or nil
---@param properties table properties table from tiled
---@param propertyType string
---@param key string | nil
---@return string | nil
function TiledHelper:getPropertyValue(properties, propertyType, key)
    if key == nil then
        for _, property in ipairs(properties) do
            if property.name == propertyType then
                return property.value
            end
        end
    else
        for _, property in ipairs(properties) do
            if property.propertytype == propertyType then
                if property.value[key] then
                    return property.value[key]
                end
            end
        end
    end
    return nil
end

return TiledHelper
