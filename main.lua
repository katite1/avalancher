F = require("util.f")
M = require("util.m")
O = require("util.o")
S = require("util.s")
Inspect = require("lib.inspect")
require("data.images")
LANG = require("assets.i18n.en")
DialogueItems = require("data.dialogue-items")
ENTITY_TYPE = require("game.entities.base.entity-type")
Debug = require("core.debug")
D = Debug:new()
local Draw = require("core.draw")
local Input = require("core.input")
local InputButton = require("core.input-button")
local MapLoader = require("core.map.map-loader")
local Camera = require("core.camera")
local World = require("game.world")
local Player = require("game.entities.player")
local Timer = require("core.timer")

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
	debugSpeedStop = InputButton:new({ "4" }),
	save = InputButton:new({ "-" }),
	load = InputButton:new({ "=" })
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


local psystem = love.graphics.newParticleSystem(SPRITES.PARTICLES.LEAF, 128)
psystem:setParticleLifetime(10, 12) -- Particles live at least 2s and at most 5s.
psystem:setEmissionRate(5)
psystem:setSizeVariation(1)
psystem:setLinearAcceleration(-3, -10, 3, 10) -- Random movement in all directions.
psystem:setEmissionArea("uniform", SCREEN.WIDTH, SCREEN.HEIGHT)
psystem:setSpeed(100, 160)
psystem:setRotation(0, 2 * math.pi)


function love.update(dt)
	require("lib.lurker").update()
	psystem:update(dt)
	input:update()

	if Buttons.debugSpeedUp.pressed then
		TICK.rate = TICK.rate * 1.01
	end
	if Buttons.debugSpeedDown.pressed then
		TICK.rate = TICK.rate / 1.01
	end
	if Buttons.debugSpeedStop.pressed then
		TICK.rate = 0
	end
	if Buttons.debugSpeedReset.pressed then
		TICK.rate = 1
	end
	TICK.current = TICK.current + 1 * TICK.rate

	if Buttons.restart.justPressed then
		restart()
	end
	if Buttons.quit.justPressed then
		love.event.quit()
	end
	if TICK.current < 1 then
		input:updateEnd()
		return
	end

	D:clear()
	D:write(1 / love.timer.getDelta())

	local iterations = math.floor(TICK.current)
	if TICK.current >= 1 then
		TICK.current = TICK.current % 1
	end

	for _ = 1, iterations, 1 do
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
	end
	input:updateEnd()
end

love.window.setFullscreen(true)

local t = 0
Draw.init()
function love.draw()
	t = t + 1
	-- love.graphics.setShader(shader)
	Draw.start()
	world.background:draw()
	camera:drawStart()
	love.graphics.draw(psystem, 0, SCREEN.HEIGHT / 2)
	world.tileMap:draw()
	world.entityManager:draw()
	-- world.entityManager:drawCollisionAreas()
	camera:drawEnd()
	love.graphics.push("all")
	love.graphics.setColor(1, 0.5, 0.55, 0.05)
	love.graphics.rectangle("fill", 0, 0, SCREEN.WIDTH, SCREEN.HEIGHT)
	love.graphics.setColor(1, 1, 1, 0.02)
	love.graphics.rectangle("fill", 0, 0, SCREEN.WIDTH, SCREEN.HEIGHT)
	love.graphics.pop()
	world.fsm:draw()
	Draw.stop()
	D:draw(2)
	-- love.graphics.setShader()
end
