local Entity = require("game.entities.base.entity")
local NpcTemplates = require("data.npcs.npc-templates")

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

---@param template NpcTemplate
---@return Npc
function Npc:new(template)
    local t = setmetatable(Entity:new(), self)
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    ---@cast t Npc
    t.type = "npc"
    t.name = template.name
    t.sprite = template.sprite
    t.dialogue = function()
        return template.dialogue(t.world, t)
    end
    return t
end

---@return SerializedNpc
function Npc:serialize()
    local serializedNpc = Entity.serialize(self)
    ---@cast serializedNpc SerializedNpc
    serializedNpc.name = self.name
    return serializedNpc
end

---@param serializedNpc SerializedNpc
---@param world World
---@return Npc
function Npc.deserialize(serializedNpc, world)
    local npc = Entity.deserialize(serializedNpc, world)
    setmetatable(npc, Npc)
    ---@cast npc Npc
    local template = NpcTemplates[serializedNpc.name]
    npc.name = template.name
    npc.sprite = template.sprite
    npc.dialogue = function()
        return template.dialogue(npc.world, npc)
    end

    return npc
end

function Npc.deserializeLdtk(ldtkEntity)
    local npcType = nil
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "npc" then
            npcType = string.lower(field.__value)
        end
    end
    local npc = Npc:new(NpcTemplates[npcType])
    -- npc.dialogueReference = dialogueReference
    return npc
end

function Npc:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Npc
