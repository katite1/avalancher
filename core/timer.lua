---@class Timer
---@field currentFrame integer
---@field frames integer
---@field fn any
---@field args any
---@field expired boolean
---@field running boolean
local Timer = {}
Timer.__index = Timer

---@param frames integer
---@param fn function|nil
---@param args any
---@return Timer
function Timer:new(frames, fn, args)
    local t = setmetatable({}, self)
    ---@cast t Timer
    t.frames = frames
    t.currentFrame = 0
    t.fn = fn
    t.args = args
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
            self.fn(self.args)
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
