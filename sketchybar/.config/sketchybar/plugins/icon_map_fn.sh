### START-OF-ICON-MAP
function icon_map() {
  case "$1" in
  "Live")
    icon_result=":ableton:"
    ;;
  "Adobe Bridge"*)
    icon_result=":adobe_bridge:"
    ;;
  "Arc")
    icon_result=":arc:"
    ;;
  "Bitwarden")
    icon_result=":bit_warden:"
    ;;
  "Brave Browser")
    icon_result=":brave_browser:"
    ;;
  "Calendar" | "Fantastical" | "Notion Calendar")
    icon_result=":calendar:"
    ;;
  "Claude")
    icon_result=":claude:"
    ;;
  "Code" | "Code - Insiders")
    icon_result=":code:"
    ;;
  "Cursor")
    icon_result=":cursor:"
    ;;
  "Discord" | "Discord Canary" | "Discord PTB")
    icon_result=":discord:"
    ;;
  "Docker" | "Docker Desktop")
    icon_result=":docker:"
    ;;
  "Figma")
    icon_result=":figma:"
    ;;
  "Finder")
    icon_result=":finder:"
    ;;
  "Firefox")
    icon_result=":firefox:"
    ;;
  "Ghostty")
    icon_result=":terminal:"
    ;;
  "GitHub Desktop")
    icon_result=":git_hub:"
    ;;
  "Chromium" | "Google Chrome" | "Google Chrome Canary")
    icon_result=":google_chrome:"
    ;;
  "iTerm" | "iTerm2")
    icon_result=":iterm:"
    ;;
  "Jellyfin Media Player")
    icon_result=":jellyfin:"
    ;;
  "kitty")
    icon_result=":kitty:"
    ;;
  "Linear")
    icon_result=":linear:"
    ;;
  "Canary Mail" | "Mail" | "Spark")
    icon_result=":mail:"
    ;;
  "Messages")
    icon_result=":messages:"
    ;;
  "mpv")
    icon_result=":mpv:"
    ;;
  "Music")
    icon_result=":music:"
    ;;
  "Neovim" | "neovim" | "nvim")
    icon_result=":neovim:"
    ;;
  "Notes")
    icon_result=":notes:"
    ;;
  "Notion")
    icon_result=":notion:"
    ;;
  "Obsidian")
    icon_result=":obsidian:"
    ;;
  "ChatGPT")
    icon_result=":openai:"
    ;;
  "Preview" | "Skim")
    icon_result=":pdf:"
    ;;
  "Raycast")
    icon_result=":raycast:"
    ;;
  "Safari" | "Safari Technology Preview")
    icon_result=":safari:"
    ;;
  "Signal")
    icon_result=":signal:"
    ;;
  "Slack")
    icon_result=":slack:"
    ;;
  "Spotify")
    icon_result=":spotify:"
    ;;
  "System Settings" | "System Preferences")
    icon_result=":gear:"
    ;;
  "Telegram")
    icon_result=":telegram:"
    ;;
  "Terminal")
    icon_result=":terminal:"
    ;;
  "Transmission")
    icon_result=":default:"
    ;;
  "VLC")
    icon_result=":vlc:"
    ;;
  "Warp")
    icon_result=":warp:"
    ;;
  "Xcode")
    icon_result=":xcode:"
    ;;
  "Zed")
    icon_result=":zed:"
    ;;
  "zoom.us")
    icon_result=":zoom:"
    ;;
  *)
    icon_result=":default:"
    ;;
  esac
}
### END-OF-ICON-MAP

icon_map "$1"

echo "$icon_result"
