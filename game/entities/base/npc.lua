local Entity = require("game.entities.base.entity")
local NPC_INDEX = require("data.npcs.index")

---@class NpcTemplate
---@field name string
---@field sprite love.Image
---@field dialogue fun(world: World, self: Npc): string[]

---@class Npc: Entity
---@field name string
---@field sprite love.Image
---@field dialogue fun(): string[]
local Npc = {}
Npc.__index = Npc
setmetatable(Npc, Entity)

---@class SerializedNpc : SerializedEntity
---@field name string

---@param world World
---@param template NpcTemplate | nil
---@return Npc
function Npc:new(world, template)
    local t = setmetatable(Entity:new(world), self)
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    ---@cast t Npc
    t.type = "npc"
    if template == nil then
        template = NPC_INDEX["bunny"] -- TODO: we need a default here
    end
    t:applyTemplate(template)
    return t
end

---@param template table
function Npc:applyTemplate(template)
    self.name = template.name
    self.sprite = template.sprite
    self.dialogue = function()
        return template.dialogue(self.world, self)
    end
end

---@return SerializedNpc
function Npc:serialize()
    local serializedNpc = Entity.serialize(self)
    ---@cast serializedNpc SerializedNpc
    serializedNpc.name = self.name
    return serializedNpc
end

---@param data SerializedNpc
function Npc:applyDeserializedData(data)
    Entity.applyDeserializedData(self, data)
    local template = NPC_INDEX[data.name]
    self:applyTemplate(template)
end

---@param ldtkEntity table
function Npc:applyLdtkData(ldtkEntity)
    local template = nil
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "npc" then
            template = string.lower(field.__value)
        end
    end

    assert(template, "Missing template name for NPC from LDtk")
    self:applyTemplate(NPC_INDEX[template])
end

function Npc:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Npc
