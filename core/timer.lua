---@class Timer
---@field currentFrame integer
---@field frames integer
---@field fn any
---@field expired boolean
---@field running boolean
---@field loop boolean
local Timer = {}
Timer.__index = Timer

---@param frames integer
---@param fn function|nil
---@return Timer
function Timer:new(frames, fn, loop)
    local t = setmetatable({}, self)
    ---@cast t Timer
    t.frames = frames
    t.currentFrame = 0
    t.fn = fn
    t.loop = loop or false
    t.expired = false
    t.running = true
    return t
end

function Timer:update()
    if self.running == false then
        return
    end
    self.currentFrame = self.currentFrame + 1
    if self.currentFrame >= self.frames then
        if self.fn then
            self.fn()
        end
        if self.loop then
            self.currentFrame = 1
            return
        end
        self.expired = true
        self.running = false
    end
end

function Timer:restart()
    self.currentFrame = 0
    self.running = true
    self.expired = false
end

function Timer:stop()
    self.running = false
end

return Timer
