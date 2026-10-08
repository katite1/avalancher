---@class Timer
---@field currentFrame integer
---@field frames integer
---@field fn any
---@field expired boolean
---@field running boolean
---@field loop boolean
local Timer = {}
Timer.__index = Timer

---@class SerializedTimer
---@field currentFrame integer
---@field frames integer
---@field expired boolean
---@field running boolean
---@field loop boolean

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

---@return SerializedTimer
function Timer:serialize()
    ---@type SerializedTimer
    return {
        currentFrame = self.currentFrame,
        frames = self.frames,
        expired = self.expired,
        running = self.running,
        loop = self.loop
    }
end

---@param timerData SerializedTimer
function Timer:applyDeserializedData(timerData)
    self.currentFrame = timerData.currentFrame
    self.frames = timerData.frames
    self.expired = timerData.expired
    self.running = timerData.running
    self.loop = timerData.loop
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
