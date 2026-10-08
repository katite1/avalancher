---@alias ItemIndex {[string]: ItemTemplate}
---@type ItemIndex
local ITEM_INDEX = {}

ITEM_INDEX.carrot = require("data.items.carrot")
ITEM_INDEX.key = require("data.items.key")

return ITEM_INDEX
