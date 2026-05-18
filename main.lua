F = require("util.f")
local Draw = require("core.draw")
local Input = require("core.input")
local InputButton = require("core.input-button")
local MapLoader = require("core.map-loader")
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

local tileMap = MapLoader:load("assets/maps/test.json")
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
	-- F.iforEach({ 12, 213, 64, 264, 5 }, function(v, i)
	-- 	love.graphics.print(v, 40, 50 + 20 * i)
	-- end)
	tileMap:draw()
	player:draw()
	camera:drawEnd()
	Draw.stop()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
