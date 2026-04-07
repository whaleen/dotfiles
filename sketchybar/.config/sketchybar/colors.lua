-- Whaleen colors for sketchybar Lua (generated — do not edit by hand)
return {
  bg       = 0xFFF8F6FF,
  fg       = 0xFF1A1A2E,
  accent   = 0xFFB86A2A,
  surface0 = 0xFFECEAF6,
  surface1 = 0xFFE2DFEF,
  surface2 = 0xFFD5D1E8,
  surface3 = 0xFFC8C4DF,
  surface4 = 0xFFBBB6D5,
  dim      = 0xFF696980,
  subtle   = 0xFF4A4A62,
  transparent = 0x00000000,

  bar = {
    bg     = 0xf0F8F6FF,
    border = 0xFFF8F6FF,
  },

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
