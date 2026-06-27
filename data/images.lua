local Asseter = require("core.asseter")

love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setLineStyle("rough")

local spritesAsseter = Asseter:new("assets/sprites/")
SPRITES = {}
SPRITES.PLAYER = spritesAsseter:load("player.png")
SPRITES.PORTAL = spritesAsseter:load("portal.png")
SPRITES.SIGN = spritesAsseter:load("sign.png")
SPRITES.PANEL = spritesAsseter:load("test-9-panel.png")

local itemAsseter = Asseter:new("assets/sprites/items/")
SPRITES.ITEMS = {}
SPRITES.ITEMS.CARROT = itemAsseter:load("carrot.png")
SPRITES.ITEMS.KEY = itemAsseter:load("key.png")

local npcAsseter = Asseter:new("assets/sprites/npcs/")
SPRITES.NPCS = {}
SPRITES.NPCS.BUNNY = npcAsseter:load("bunny/bunny.png")

local backgroundsAsseter = Asseter:new("assets/backgrounds/")
BACKGROUNDS = {}
BACKGROUNDS.PLAINS = {}
BACKGROUNDS.PLAINS.BASE = backgroundsAsseter:load("plains/plains-base.png", true)
BACKGROUNDS.PLAINS.MOUNTAINS = backgroundsAsseter:load("plains/mountains.png", true)
BACKGROUNDS.PLAINS.GRASS = backgroundsAsseter:load("plains/grass.png", true)
