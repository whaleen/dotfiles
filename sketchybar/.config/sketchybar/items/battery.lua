local colors   = require("colors")
local settings = require("settings")
local icons    = require("icons")

local battery = sbar.add("item", "battery", {
  position    = "right",
  update_freq = 180,
  icon = {
    font  = { family = settings.font.icons, style = "Regular", size = 13.0 },
    color = colors.fg,
  },
  label = {
    font  = { family = settings.font.numbers, style = "Regular", size = 12.0 },
    color = colors.fg,
  },
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
  sbar.exec("pmset -g batt", function(batt)
    local found, _, charge = batt:find("(%d+)%%")
    if not found then return end
    charge = tonumber(charge)

    local icon  = icons.battery._0
    local color = colors.fg
    local charging = batt:find("AC Power")

    if charging then
      icon  = icons.battery.charging
      color = colors.accent
    elseif charge > 80 then icon = icons.battery._100
    elseif charge > 60 then icon = icons.battery._75
    elseif charge > 40 then icon = icons.battery._50
    elseif charge > 20 then icon = icons.battery._25
    else color = 0xfffc5d7c end

    battery:set({
      icon  = { string = icon, color = color },
      label = { string = charge .. "%" },
    })
  end)
end)
