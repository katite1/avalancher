F = require("util.f")
M = require("util.m")
O = require("util.o")
S = require("util.s")
Inspect = require("lib.inspect")
require("data.images")
LANG = require("assets.i18n.en")
DialogueItems = require("game.dialogue-items")
local Draw = require("core.draw")
local Input = require("core.input")
local InputButton = require("core.input-button")
local MapLoader = require("core.map.map-loader")
local Camera = require("core.camera")
local World = require("game.world")
local Player = require("game.entities.player")
local Inventory = require("game.inventory")

local function init()
	local font = love.graphics.newFont("assets/font/monogram.ttf", 16)
	love.graphics.setFont(font)
end

init()

SCREEN = {}
SCREEN.WIDTH = 320
SCREEN.HEIGHT = 180



TICK = {}
TICK.rate = 1
TICK.current = 0


local shader = love.graphics.newShader("assets/test-shader.fs")


Buttons = {
	left = InputButton:new({ "left" }),
	right = InputButton:new({ "right" }),
	up = InputButton:new({ "up" }),
	down = InputButton:new({ "down" }),
	jump = InputButton:new({ "z" }),
	action = InputButton:new({ "x" }),
	inventory = InputButton:new({ "f" }),
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
world.background:register("Plains", require("data.backgrounds.plains"))

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
			world.background.parallaxX = -camera.x
			world.background.parallaxY = -camera.y
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
Draw.init()
function love.draw()
	t = t + 1
	-- love.graphics.setShader(shader)
	Draw.start()
	world.background:draw()
	camera:drawStart()
	world.tileMap:draw()
	world.entityManager:draw()
	camera:drawEnd()
	world.fsm:draw()
	Draw.stop()
	-- love.graphics.setShader()
end
