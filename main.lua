F = require("util.f")
M = require("util.m")
local Draw = require("core.draw")
local Input = require("core.input")
local InputButton = require("core.input-button")
local MapLoader = require("core.map.map-loader")
local Camera = require("core.camera")
local Player = require("game.player")

SCREEN = {}
SCREEN.WIDTH = 240
SCREEN.HEIGHT = 136

local buttons = {
	left = InputButton:new({ "left", "a" }),
	right = InputButton:new({ "right", "d" }),
	up = InputButton:new({ "up", "w" }),
	down = InputButton:new({ "down", "s" }),
}
local input = Input:new()
F.forEach(buttons, function(_, button)
	input:register(button)
end)

local function init()
	love.graphics.setDefaultFilter("nearest", "nearest")
	local font = love.graphics.newFont("assets/font/monogram.ttf", 16)
	love.graphics.setFont(font)
end

init()

local camera = Camera:new()

local mapLoader = MapLoader:new(
	"assets/maps/",
	love.graphics.newImage("assets/maps/world_tileset.png")
)
local tileMap = mapLoader:load("test.json")
if not tileMap then
	return
end

local player = Player:new()
player.x = 20
player.y = 20

function love.update()
	input:update()

	if buttons.left.pressed then
		player.x = player.x - 4
	end
	if buttons.right.pressed then
		player.x = player.x + 4
	end
	if buttons.up.pressed then
		player.y = player.y - 4
	end
	if buttons.down.pressed then
		player.y = player.y + 4
	end
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
	player:draw()
	local tiles = tileMap:getTilesInRectangle(player.x, player.y, 32, 24)
	camera:drawEnd()
	love.graphics.print(#tiles, 10, 10)
	if #tiles > 0 then
		love.graphics.print("collision", 10, 10)
	end
	Draw.stop()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
