---@class Draw
---@field canvas love.Canvas
local Draw = {}
Draw.__index = Draw

function Draw.init()
    Draw.canvas = love.graphics.newCanvas(SCREEN.WIDTH, SCREEN.HEIGHT)
end

function Draw.start()
    love.graphics.setCanvas(Draw.canvas)
    love.graphics.push()
    love.graphics.push("all")
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, 0, SCREEN.WIDTH, SCREEN.HEIGHT)
    love.graphics.pop()
end

function Draw.stop()
    local w, h = love.graphics.getDimensions()
    local fitW = w / SCREEN.WIDTH
    local fitH = h / SCREEN.HEIGHT
    local fit  = math.floor(math.min(fitW, fitH))
    local gapW = math.floor((w - SCREEN.WIDTH * fit) / 2)
    local gapH = math.floor((h - SCREEN.HEIGHT * fit) / 2)
    love.graphics.setCanvas()
    love.graphics.draw(Draw.canvas, gapW, gapH, 0, fit, fit)
    love.graphics.pop()
end

return Draw
