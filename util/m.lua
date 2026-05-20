local m = {}

---@param v number
function m.round(v)
    -- https://stackoverflow.com/a/26777901
    return v >= 0 and math.floor(v + 0.5) or math.ceil(v - 0.5)
end

---@param v number
---@param min number
---@param max number
function m.clamp(v, min, max)
    return math.min(math.max(v, min), max)
end

return m
