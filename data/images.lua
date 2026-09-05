local Asseter = require("core.asseter")

love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setLineStyle("rough")

IMAGES = {}
local spritesAsseter = Asseter:new("assets/sprites/")
IMAGES.SPRITES = {}
IMAGES.SPRITES.PLAYER = spritesAsseter:load("player.png")
IMAGES.SPRITES.MUSHROOM_WALK = spritesAsseter:load("enemies/mushroom/mushroom-walk.png")
IMAGES.SPRITES.MUSHROOM_IDLE = spritesAsseter:load("enemies/mushroom/mushroom-idle.png")
IMAGES.SPRITES.MUSHROOM_STOMPED = spritesAsseter:load("enemies/mushroom/mushroom-stomped.png")
IMAGES.SPRITES.PORTAL = spritesAsseter:load("portal.png")
IMAGES.SPRITES.SIGN = spritesAsseter:load("sign.png")
IMAGES.SPRITES.PANEL = spritesAsseter:load("test-9-panel.png")

local particleAsseter = Asseter:new("assets/sprites/particles/")
IMAGES.SPRITES.PARTICLES = {}
IMAGES.SPRITES.PARTICLES.LEAF = particleAsseter:load("leaf.png")

local itemAsseter = Asseter:new("assets/sprites/items/")
IMAGES.SPRITES.ITEMS = {}
IMAGES.SPRITES.ITEMS.CARROT = itemAsseter:load("carrot.png")
IMAGES.SPRITES.ITEMS.KEY = itemAsseter:load("key.png")

local npcAsseter = Asseter:new("assets/sprites/npcs/")
IMAGES.SPRITES.NPCS = {}
IMAGES.SPRITES.NPCS.BUNNY = npcAsseter:load("bunny/bunny.png")

local backgroundsAsseter = Asseter:new("assets/backgrounds/")
IMAGES.BACKGROUNDS = {}
IMAGES.BACKGROUNDS.PLAINS = {}
IMAGES.BACKGROUNDS.PLAINS.BASE = backgroundsAsseter:load("plains/plains-base.png", true)
IMAGES.BACKGROUNDS.PLAINS.MOUNTAINS = backgroundsAsseter:load("plains/mountains.png", true)
IMAGES.BACKGROUNDS.PLAINS.GRASS = backgroundsAsseter:load("plains/grass.png", true)
