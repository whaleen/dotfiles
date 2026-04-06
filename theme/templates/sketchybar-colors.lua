-- {{THEME_NAME}} colors for sketchybar Lua (generated — do not edit by hand)
return {
  bg       = {{BG_LUA}},
  fg       = {{FG_LUA}},
  accent   = {{ACCENT_LUA}},
  surface0 = {{SURFACE0_LUA}},
  surface1 = {{SURFACE1_LUA}},
  surface2 = {{SURFACE2_LUA}},
  surface3 = {{SURFACE3_LUA}},
  surface4 = {{SURFACE4_LUA}},
  dim      = {{DIM_LUA}},
  subtle   = {{SUBTLE_LUA}},
  transparent = 0x00000000,

  bar = {
    bg     = {{BG_LUA_F0}},
    border = {{BG_LUA}},
  },

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
