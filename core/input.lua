local InputButtom = require("core.input-button")

---@class Input
---@field buttons InputButton[]
local Input = {}

---@return Input
function Input:new()
    local t = setmetatable({}, { __index = self })
    t.buttons = {}
    return t
end

---@param button InputButton
function Input:register(button)
    table.insert(self.buttons, button)
end

function Input:update()
    F.iforEach(self.buttons, function(button)
        local pressed = F.iany(button.keys, function(key)
            if love.keyboard.isDown(key) then
                return true
            end
            return false
        end)
        button.justPressed = false
        button.justReleased = false
        if pressed then
            button.pressed = true
            button.released = false
        else
            button.pressed = false
            button.released = true
        end
        if pressed and button.lastState == false then
            button.justPressed = true
        end
        if not pressed and button.lastState == true then
            button.justReleased = true
        end
    end)
end

function Input:updateEnd()
    F.iforEach(self.buttons, function(button)
        button.lastState = button.pressed
    end)
end

return Input
