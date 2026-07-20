local Player = require("game.entities.player")
local Mushroom = require("game.entities.mushroom.mushroom")
local Portal = require("game.entities.portal")
local Item = require("game.entities.base.item")
local Npc = require("game.entities.base.npc")

---@enum (key) EntityType
local ENTITY_TYPE = {
    player = Player,
    mushroom = Mushroom,
    portal = Portal,
    item = Item,
    npc = Npc,
}

return ENTITY_TYPE
