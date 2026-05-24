local o = {}

---Returns whether the object is an instance of the class
---@param o table
---@param class table
---@return boolean
function o.isInstance(o, class)
    while o do
        o = getmetatable(o)
        if class == o then return true end
    end
    return false
end

return o
