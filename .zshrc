# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Cursor CLI
export PATH="/Applications/Cursor.app/Contents/Resources/app/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/josh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/.local/bin:$PATH"

# bun
[ -s "/Users/josh/.bun/_bun" ] && source "/Users/josh/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Solana + Rust
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH="$HOME/.cargo/bin:$HOME/.avm/bin:$PATH"

# Ghostty completion enhancements
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' squeeze-slashes true

# History search with arrow keys
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# zsh plugins (autosuggestions + syntax highlighting)
for f in \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
do
  [ -f "$f" ] && source "$f" && break
done
for f in \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
do
  [ -f "$f" ] && source "$f" && break
done

# fzf
if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
  else
    [ -f /usr/local/opt/fzf/shell/completion.zsh ] && source /usr/local/opt/fzf/shell/completion.zsh
    [ -f /usr/local/opt/fzf/shell/key-bindings.zsh ] && source /usr/local/opt/fzf/shell/key-bindings.zsh
    [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
    [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  fi
fi

# yt-dlp + fzf + VLC
_yt_pick_browser() {
  local n="${1:-80}"
  local feed_url="https://www.youtube.com/feed/subscriptions"
  local browsers=(chrome brave safari)
  local b out

  for b in "${browsers[@]}"; do
    out="$(yt-dlp "$feed_url" \
      --cookies-from-browser "$b" \
      --flat-playlist \
      --playlist-end "$n" \
      --print "%(title)s\t%(webpage_url)s" 2>/dev/null || true)"
    if [ -n "$out" ]; then
      printf '%s\n' "$out"
      return 0
    fi
  done
  return 1
}

_yt_open_vlc() {
  local url="${1:-}"
  [ -n "$url" ] || return 1
  local stream
  stream="$(yt-dlp -g "$url" 2>/dev/null | head -n1 || true)"
  if [ -n "$stream" ]; then
    open -a VLC "$stream"
  else
    open -a VLC "$url"
  fi
}

ytsub() {
  local n="${1:-80}"
  local picked
  picked="$(_yt_pick_browser "$n" \
    | fzf --height=80% --layout=reverse --border --prompt='YouTube subs > ' --with-nth=1 --delimiter=$'\t' \
    | awk -F '\t' '{print $2}')"
  if [ -z "$picked" ]; then
    echo "ytsub: no selection or subscriptions unavailable." >&2
    return 1
  fi
  _yt_open_vlc "$picked"
}

ytsearch() {
  local q="${1:-}"
  local n="${2:-40}"
  local picked
  if [ -z "$q" ]; then
    echo 'usage: ytsearch "query" [count]' >&2
    return 1
  fi
  picked="$(yt-dlp "ytsearch${n}:$q" --flat-playlist --print "%(title)s\t%(webpage_url)s" 2>/dev/null \
    | fzf --height=80% --layout=reverse --border --prompt='YT search > ' --with-nth=1 --delimiter=$'\t' \
    | awk -F '\t' '{print $2}')"
  [ -n "$picked" ] && _yt_open_vlc "$picked"
}

ytplay() {
  local url="${1:-}"
  if [ -z "$url" ]; then
    echo 'usage: ytplay <youtube-url>' >&2
    return 1
  fi
  _yt_open_vlc "$url"
}

ytpick() { ytsub "$@"; }
ytsearchvlc() { ytsearch "$@"; }
ytsubvlc() { ytsub "$@"; }
ytvlc() { ytplay "$@"; }
alias yt='ytsub'

# zoxide
eval "$(zoxide init zsh)"

# broot
source /Users/josh/.config/broot/launcher/bash/br

# AI CLI YOLO Aliases
alias codex="codex --dangerously-bypass-approvals-and-sandbox"
alias claude="claude --dangerously-skip-permissions"
