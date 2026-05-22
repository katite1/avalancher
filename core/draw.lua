---@class Draw
---@field canvas love.Canvas
local Draw = {}
Draw.__index = Draw

-- function Draw.start()
--     local w, h = love.graphics.getDimensions()
--     local fitW = w / SCREEN.WIDTH
--     local fitH = h / SCREEN.HEIGHT
--     local fit  = math.floor(math.min(fitW, fitH))
--     local gapW = (w - SCREEN.WIDTH * fit) / 2
--     local gapH = (h - SCREEN.HEIGHT * fit) / 2

--     love.graphics.push()
--     love.graphics.setScissor(gapW, gapH, w - gapW * 2, h - gapH * 2)
--     love.graphics.translate(gapW, gapH)
--     love.graphics.scale(fit, fit)
-- end

-- function Draw.stop()
--     love.graphics.setScissor()
--     love.graphics.pop()
-- end

function Draw.start()
    local w, h  = love.graphics.getDimensions()
    local fitW  = w / SCREEN.WIDTH
    local fitH  = h / SCREEN.HEIGHT
    local fit   = math.floor(math.min(fitW, fitH))
    local gapW  = (w - SCREEN.WIDTH * fit) / 2
    local gapH  = (h - SCREEN.HEIGHT * fit) / 2

    Draw.canvas = love.graphics.newCanvas(SCREEN.WIDTH, SCREEN.HEIGHT)
    love.graphics.setCanvas(Draw.canvas)
    love.graphics.push()
    -- love.graphics.setScissor(gapW, gapH, w - gapW * 2, h - gapH * 2)
    -- love.graphics.translate(gapW, gapH)
    -- love.graphics.scale(fit, fit)
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
    love.graphics.setScissor()
    love.graphics.pop()
end

return Draw
