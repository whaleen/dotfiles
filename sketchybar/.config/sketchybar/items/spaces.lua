local colors     = require("colors")
local settings   = require("settings")
local app_icons  = require("helpers.app_icons")

local spaces = {}

for i = 1, 9 do
  local space = sbar.add("space", "space." .. i, {
    space    = i,
    position = "left",
    icon = {
      string        = i,
      font          = { family = settings.font.text, style = "Regular", size = 11.0 },
      color         = colors.dim,
      highlight_color = colors.accent,
      padding_left  = 6,
      padding_right = 3,
    },
    label = {
      font          = { family = settings.font.app, style = "Regular", size = 14.0 },
      color         = colors.subtle,
      highlight_color = colors.fg,
      padding_left  = 1,
      padding_right = 6,
      y_offset      = -1,
    },
    background = {
      color         = colors.with_alpha(colors.fg, 0.07),
      border_width  = 1,
      border_color  = colors.with_alpha(colors.fg, 0.0),
      height        = 18,
      corner_radius = 4,
    },
    click_script = "yabai -m space --focus " .. i,
  })

  spaces[i] = space

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    space:set({
      icon  = { highlight = selected },
      label = { highlight = selected },
      background = {
        border_color = selected
          and colors.with_alpha(colors.accent, 0.5)
          or  colors.with_alpha(colors.fg, 0.0),
        color = selected
          and colors.with_alpha(colors.accent, 0.15)
          or  colors.with_alpha(colors.fg, 0.07),
      },
    })
  end)
end

-- Observer item that listens for window changes and updates app icons
local observer = sbar.add("item", { drawing = false, updates = true })

observer:subscribe("space_windows_change", function(env)
  local icon_line = ""
  local no_app = true
  for app, _ in pairs(env.INFO.apps) do
    no_app = false
    local lookup = app_icons[app]
    icon_line = icon_line .. (lookup or app_icons["Default"])
  end
  if no_app then icon_line = "" end

  sbar.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({ label = { string = icon_line } })
  end)
end)
