---@type NpcTemplate
local bunny = {
    name = "bunny",
    sprite = SPRITES.NPCS.BUNNY,
    dialogue = function(world, self)
        if world.progressEntries.entry.bunny:isCompleted() then
            return { LANG.misterBunny.goAway }
        end
        if world.inventory:get("carrot") then
            world.inventory:remove("carrot")
            world.progressEntries.entry.bunny.progress = true
            return { LANG.misterBunny.carrots }
        end

        return {
            LANG.misterBunny.greeting,
            LANG.misterBunny.desperation,
            LANG.misterBunny.thankyou,
        }
    end
}

return bunny
