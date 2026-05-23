F = require("util.f")
M = require("util.m")
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
SCREEN.WIDTH = 240
SCREEN.HEIGHT = 136

SPRITES_PATH = "assets/sprites/"
SPRITES = {}
SPRITES.PLAYER = love.graphics.newImage(SPRITES_PATH .. "player.png")

Buttons = {
	left = InputButton:new({ "left", "a" }),
	right = InputButton:new({ "right", "d" }),
	up = InputButton:new({ "up", "w" }),
	down = InputButton:new({ "down", "s" }),
	jump = InputButton:new({ "z", "j" }),
}
local input = Input:new()
F.forEach(Buttons, function(_, button)
	input:register(button)
end)


local camera = Camera:new()

local mapLoader = MapLoader:new(
	"assets/maps/",
	love.graphics.newImage("assets/maps/world_tileset.png")
)
local tileMap = mapLoader:load("test.json")
if not tileMap then
	return
end

local world = World:new(tileMap)
local player = world.entityManager:make(Player)
player.x = 100

function love.update()
	require("lib.lurker").update()

	input:update()

	world.entityManager:update()

	camera.x = player.x - SCREEN.WIDTH / 2
	camera.y = player.y - SCREEN.HEIGHT / 2

	input:updateEnd()
end

function love.draw()
	Draw.start()
	love.graphics.push("all")
	love.graphics.setColor(0.2, 0.2, 0.2)
	love.graphics.rectangle("fill", 0, 0, SCREEN.WIDTH, SCREEN.HEIGHT)
	love.graphics.pop()
	camera:drawStart()
	tileMap:draw()
	world.entityManager:draw()
	camera:drawEnd()
	Draw.stop()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
