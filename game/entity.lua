---@class Entity
---@field x number
---@field y number
---@field update function
---@field draw function | nil
---@field new function
---@field xRemainder number
local Entity = {}
Entity.__index = Entity

function Entity:new()
    local t = setmetatable({}, self)
    t.x = 0
    t.y = 0
    t.xRemainder = 0
    return t
end

function Entity:update()
    print("test")
end

-- function Entity:moveX(amount)
--     self.xRemainder = self.xRemainder + amount
--     local move = M.round(self.xRemainder)
--     if move ~= 0 then
--         self.xRemainder = self.xRemainder - move
--         local sign = M.sign(move)
--         while move ~= 0 do
--             if not collideAt(solids, Position + new Vector2(sign, 0)) then
--                 self.x = self.x + sign;
--                 move = move - sign
--             else
--                 break
--             end
--         end
--     end
-- end

return Entity
