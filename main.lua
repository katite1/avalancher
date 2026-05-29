F = require("util.f")
M = require("util.m")
O = require("util.o")
Inspect = require("lib.inspect")
LANG = require("assets.i18n.en")
DialogueItems = require("game.dialogue-items")
local Draw = require("core.draw")
local Input = require("core.input")
local InputButton = require("core.input-button")
local MapLoader = require("core.map.map-loader")
local Camera = require("core.camera")
local World = require("game.world")
local Player = require("game.player")
local Panel = require("game.ui.panel")

local function init()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")
	local font = love.graphics.newFont("assets/font/monogram.ttf", 16)
	love.graphics.setFont(font)
end

init()

SCREEN = {}
SCREEN.WIDTH = 320
SCREEN.HEIGHT = 180

SPRITES_PATH = "assets/sprites/"
SPRITES = {}
SPRITES.PLAYER = love.graphics.newImage(SPRITES_PATH .. "player.png")
SPRITES.SIGN = love.graphics.newImage(SPRITES_PATH .. "sign.png")
SPRITES.PANEL = love.graphics.newImage(SPRITES_PATH .. "test-9-panel.png")

Buttons = {
	left = InputButton:new({ "left", "a" }),
	right = InputButton:new({ "right", "d" }),
	up = InputButton:new({ "up", "w" }),
	down = InputButton:new({ "down", "s" }),
	jump = InputButton:new({ "z", "j" }),
	talk = InputButton:new({ "up" })
}
local input = Input:new()
F.forEach(Buttons, function(_, button)
	input:register(button)
end)


local camera = Camera:new()

local world = World:new()

local mapLoader = MapLoader:new(
	"assets/maps/",
	love.graphics.newImage("assets/maps/world_tileset.png"),
	world
)
mapLoader:load("test.json")

local testPanel = Panel:new(SPRITES.PANEL, 8)

function love.update()
	require("lib.lurker").update()

	input:update()

	world.fsm:update()

	local players = world.entityManager:getAll(Player)
	if players then
		camera.x = players[1].x - SCREEN.WIDTH / 2
		camera.y = players[1].y - SCREEN.HEIGHT / 2
	end

	input:updateEnd()
end

local t = 0
function love.draw()
	t = t + 1
	Draw.start()
	love.graphics.push("all")
	love.graphics.setColor(0.2, 0.2, 0.2)
	love.graphics.rectangle("fill", 0, 0, SCREEN.WIDTH, SCREEN.HEIGHT)
	love.graphics.pop()
	camera:drawStart()
	world.tileMap:draw()
	world.entityManager:draw()
	camera:drawEnd()
	-- testPanel:draw(SCREEN.WIDTH - 16, 32)
	-- testPanel:draw(SCREEN.WIDTH, 100 + math.sin(t / 10) * 30)
	world.fsm:draw()
	Draw.stop()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
