local colors   = require("colors")
local settings = require("settings")

sbar.default({
  icon = {
    font = {
      family = settings.font.icons,
      style  = "Regular",
      size   = 13.0,
    },
    color         = colors.fg,
    padding_left  = settings.paddings,
    padding_right = settings.paddings,
  },
  label = {
    font = {
      family = settings.font.text,
      style  = settings.font.style_map["Regular"],
      size   = 12.0,
    },
    color         = colors.fg,
    padding_left  = settings.paddings,
    padding_right = settings.paddings,
  },
  background = {
    height        = 20,
    corner_radius = 4,
    border_width  = 0,
  },
  padding_left  = 3,
  padding_right = 3,
  updates       = "when_shown",
})
