local Entity = require("game.entities.base.entity")
local NpcTemplates = require("data.npcs.npc-templates")

---@class NpcTemplate
---@field name string
---@field sprite love.Image

---@class Npc: Entity
---@field name string
---@field sprite love.Image
local Npc = {}
Npc.__index = Npc
setmetatable(Npc, Entity)

---@param template NpcTemplate
---@return Npc
function Npc:new(template)
    local t = setmetatable(Entity:new(), self)
    t.bb = { x = 2, y = 4, w = 12, h = 12 }
    ---@cast t Npc
    t.name = template.name
    t.sprite = template.sprite
    return t
end

function Npc:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Npc.deserializeLdtk(ldtkEntity)
    local npcType = nil
    local dialogueReference = nil
    for _, field in ipairs(ldtkEntity.fieldInstances) do
        if field.__identifier == "npc" then
            npcType = string.lower(field.__value)
        end
        if field.__identifier == "dialogue_reference" then
            dialogueReference = field.__value
        end
    end
    local npc = Npc:new(NpcTemplates[npcType])
    npc.dialogueReference = dialogueReference
    return npc
end

return Npc
