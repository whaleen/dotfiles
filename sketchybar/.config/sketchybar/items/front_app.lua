local colors   = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  position = "left",
  icon     = { drawing = false },
  label    = {
    font  = { family = settings.font.text, style = settings.font.style_map["Bold"], size = 12.0 },
    color = colors.subtle,
  },
  updates  = true,
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)
