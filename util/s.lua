local s = {}

-- https://github.com/subsoap/defstring/blob/master/defstring/defstring.lua#L37
-- Splits a string into a table based on a delimiter
-- split('a,b,c', ',') returns {'a', 'b', 'c'}
function s.split(s, delimiter)
    delimiter = delimiter or '%s'
    local t = {}
    local i = 1
    for str in string.gmatch(s, '([^' .. delimiter .. ']+)') do
        t[i] = str
        i = i + 1
    end
    return t
end

return s
