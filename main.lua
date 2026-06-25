F = require("util.f")
M = require("util.m")
O = require("util.o")
S = require("util.s")
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
SPRITES.PORTAL = love.graphics.newImage(SPRITES_PATH .. "portal.png")
TILESETS_PATH = "assets/maps/"
TILESETS = {}
TILESETS["grass.png"] = love.graphics.newImage(TILESETS_PATH .. "grass.png")
TILESETS["snow.png"] = love.graphics.newImage(TILESETS_PATH .. "snow.png")
BACKGROUNDS_PATH = "assets/backgrounds/"
BACKGROUNDS = {}
BACKGROUNDS.PLAINS = love.graphics.newImage(BACKGROUNDS_PATH .. "plains.png")
BACKGROUNDS.PLAINS:setWrap('repeat', 'repeat')


TICK = {}
TICK.rate = 1
TICK.current = 0


local shader = love.graphics.newShader("assets/test-shader.fs")


Buttons = {
	left = InputButton:new({ "left", "a" }),
	right = InputButton:new({ "right", "d" }),
	up = InputButton:new({ "up", "w" }),
	down = InputButton:new({ "down", "s" }),
	jump = InputButton:new({ "z", "j" }),
	talk = InputButton:new({ "up" }),
	restart = InputButton:new({ "r" }),
	quit = InputButton:new({ "escape" }),
	debugSpeedDown = InputButton:new({ "1" }),
	debugSpeedUp = InputButton:new({ "2" }),
	debugSpeedReset = InputButton:new({ "3" }),
}
local input = Input:new()
F.forEach(Buttons, function(_, button)
	input:register(button)
end)

local camera = Camera:new()
local world = World:new()
local mapLoader = MapLoader:new(
	"assets/maps/",
	"maps.ldtk",
	world
)
world.mapLoader = mapLoader
mapLoader:load("maps/Plains_1.ldtkl")
local function restart()
	camera = Camera:new()
	world = World:new()
	mapLoader = MapLoader:new(
		"assets/maps/",
		"maps.ldtk",
		world
	)
	mapLoader:load("maps/Plains_1.ldtkl")
end


function love.update()
	require("lib.lurker").update()
	if Buttons.debugSpeedUp.pressed then
		TICK.rate = TICK.rate * 1.01
	end
	if Buttons.debugSpeedDown.pressed then
		TICK.rate = TICK.rate / 1.01
	end
	if Buttons.debugSpeedReset.pressed then
		TICK.rate = 1
	end
	TICK.current = TICK.current + 1 * TICK.rate
	if TICK.current < 1 then
		return
	end

	local iterations = math.floor(TICK.current)
	if TICK.current >= 1 then
		TICK.current = TICK.current % 1
	end

	for _ = 1, iterations, 1 do
		input:update()

		world.fsm:update()

		local players = world.entityManager:getAll(Player)
		if players then
			camera.x = players[1].x - SCREEN.WIDTH / 2
			camera.y = players[1].y - SCREEN.HEIGHT / 2
			camera.x = M.clamp(camera.x, 0, world.tileMap.width - SCREEN.WIDTH)
			camera.y = M.clamp(camera.y, 0, world.tileMap.height - SCREEN.HEIGHT)
		end

		if Buttons.restart.justPressed then
			restart()
		end
		if Buttons.quit.justPressed then
			love.event.quit()
		end

		input:updateEnd()
	end
end

local t = 0
local bgQuad = love.graphics.newQuad(0, 0, SCREEN.WIDTH, SCREEN.HEIGHT, BACKGROUNDS.PLAINS)
Draw.init()
function love.draw()
	t = t + 1
	-- love.graphics.setShader(shader)
	Draw.start()
	love.graphics.draw(BACKGROUNDS.PLAINS, bgQuad, 0, 0)
	camera:drawStart()
	world.tileMap:draw()
	world.entityManager:draw()
	camera:drawEnd()
	world.fsm:draw()
	Draw.stop()
	-- love.graphics.setShader()
end
