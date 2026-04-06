local colors   = require("colors")
local settings = require("settings")
local icons    = require("icons")

local clock = sbar.add("item", "clock", {
  position     = "right",
  update_freq  = 30,
  icon = {
    string        = icons.clock,
    font          = { family = settings.font.icons, style = "Regular", size = 13.0 },
    color         = colors.accent,
    padding_right = 2,
  },
  label = {
    font  = { family = settings.font.numbers, style = "Regular", size = 12.0 },
    color = colors.fg,
  },
})

clock:subscribe({ "routine", "forced", "system_woke" }, function()
  clock:set({ label = { string = os.date("%a %b %d  %H:%M") } })
end)
