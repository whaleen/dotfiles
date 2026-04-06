local colors   = require("colors")
local settings = require("settings")
local icons    = require("icons")

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    font  = { family = settings.font.icons, style = "Regular", size = 13.0 },
    color = colors.fg,
  },
  label = {
    font  = { family = settings.font.numbers, style = "Regular", size = 12.0 },
    color = colors.fg,
  },
})

volume:subscribe("volume_change", function(env)
  local vol  = tonumber(env.INFO)
  local icon = icons.volume._0
  if     vol > 60 then icon = icons.volume._100
  elseif vol > 30 then icon = icons.volume._66
  elseif vol > 0  then icon = icons.volume._33
  end
  volume:set({
    icon  = { string = icon },
    label = { string = vol .. "%" },
  })
end)
