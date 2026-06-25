local json        = require("lib.json")
local TileMap     = require("core.map.tile-map")
local Player      = require("game.player")
local Sign        = require("game.sign")
local Portal      = require("game.portal")

---@class MapLoader
---@field directory string
---@field rootMap table
---@field world World
local MapLoader   = {}
MapLoader.__index = MapLoader

---@param directory string
---@return MapLoader
function MapLoader:new(directory, rootMap, world)
    local t = setmetatable({}, { __index = self })
    t.rootMap = json.decode(love.filesystem.read(directory .. rootMap))
    t.directory = directory
    t.world = world
    return t
end

---@param mapName string
function MapLoader:load(mapName)
    local map = json.decode(love.filesystem.read(self.directory .. mapName))
    local tileMap = TileMap:new(16, map.pxWid, map.pxHei)
    if map.fieldInstances then
        for _, fieldInstance in ipairs(map.fieldInstances) do
            if fieldInstance.__identifier == "Background" then
                self.world.background:set(fieldInstance.__value)
            end
        end
    end
    if map.layerInstances then
        for _, layer in ipairs(map.layerInstances) do
            if layer.__tilesetRelPath then
                local image = love.graphics.newImage(self.directory .. layer.__tilesetRelPath)
                tileMap:addTileset(layer.__tilesetRelPath, image)
            end
            if layer.__type == "AutoLayer" then
                local tags = {}
                for _, layerDef in ipairs(self.rootMap.defs.layers) do
                    if layerDef.identifier == layer.__identifier then
                        if layerDef.doc ~= nil then
                            tags = S.split(layerDef.doc, ",")
                        end
                    end
                end
                tileMap:addLayer(layer, tags)
            end
            if layer.__type == "Entities" then
                self:createObjects(layer)
            end
        end
    end

    self.world.tileMap = tileMap
end

---@param layer table
function MapLoader:createObjects(layer)
    for _, entity in ipairs(layer.entityInstances) do
        local e = nil
        if entity.__identifier == "Player" then
            e = self.world.entityManager:makeFromLdtk(Player)
        end

        if entity.__identifier == "Sign" then
            e = self.world.entityManager:makeFromLdtk(Sign, entity)
        end
        if entity.__identifier == "Portal" then
            e = self.world.entityManager:makeFromLdtk(Portal, entity)
        end
        if e then
            e.x = entity.px[1]
            e.y = entity.px[2]
        end
    end
end

return MapLoader
