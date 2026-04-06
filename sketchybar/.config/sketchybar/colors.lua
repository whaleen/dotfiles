-- Whaleen colors for sketchybar Lua (generated — do not edit by hand)
return {
  bg       = 0xFF101010,
  fg       = 0xFFffffff,
  accent   = 0xFFC3A6FF,
  surface0 = 0xFF161616,
  surface1 = 0xFF1C1C1C,
  surface2 = 0xFF232323,
  surface3 = 0xFF282828,
  surface4 = 0xFF343434,
  dim      = 0xFF7E7E7E,
  subtle   = 0xFFA0A0A0,
  transparent = 0x00000000,

  bar = {
    bg     = 0xf0101010,
    border = 0xFF101010,
  },

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
