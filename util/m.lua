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

-- https://love2d.org/forums/viewtopic.php?t=9395 @ Ref
---@param rgb string
---@return number
---@return number
---@return number
function m.hex_to_rgb(rgb)
    local _, _, r, g, b, a = rgb:find('(%x%x)(%x%x)(%x%x)')
    r = tonumber(r, 16) / 255
    g = tonumber(g, 16) / 255
    b = tonumber(b, 16) / 255
    return r, g, b
end

return m
