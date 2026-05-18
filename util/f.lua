local f = {}

---@generic T
---@param t T[]
---@param fn fun(k: any, v: T)
function f.forEach(t, fn)
	for key, value in pairs(t) do
		fn(key, value)
	end
end

---@generic T
---@param t T[]
---@param fn fun(v: T, i: number)
function f.iforEach(t, fn)
	if #t == 0 then return end
	for index, value in ipairs(t) do
		fn(value, index)
	end
end

---@generic T
---@param t T[]
---@param fn fun(v: T, i: number): boolean
---@return boolean
function f.iany(t, fn)
	if #t == 0 then return false end
	for index, value in ipairs(t) do
		if fn(value, index) then
			return true
		end
	end
	return false
end

return f
