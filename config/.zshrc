# ====================================================================
#  Zsh Configuration - High Performance & Full Vim Control
# ====================================================================

# --- Environment & Defaults ---
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'

# Catppuccin Macchiato colors for FZF
export FZF_DEFAULT_OPTS='
  --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
  --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
  --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
  --height=40% --layout=reverse --border
'

# Colored man pages via less
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# --- Path Configuration ---
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.n/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.bun/bin"
    "$HOME/.deno/bin"
    $path
)
export PATH

# --- History Configuration ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY          # Write history in :start:elapsed;command format
setopt SHARE_HISTORY             # Share history across terminals
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming
setopt HIST_IGNORE_DUPS          # Do not record an entry that was just recorded
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicate entry if new one is entered
setopt HIST_FIND_NO_DUPS         # Do not display duplicates when searching
setopt HIST_IGNORE_SPACE         # Do not record entries starting with space
setopt HIST_SAVE_NO_DUPS         # Do not write duplicate entries to file
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording
setopt AUTO_CD                   # Type directory name to cd into it
setopt EXTENDED_GLOB             # Advanced globbing features

# --- Completion System ---
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
compinit -d "$HOME/.zcompdump"

# --- Zsh Autosuggestions ---
if [[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5b6078"
    bindkey '^ ' autosuggest-accept       # Ctrl + Space to accept suggestion
fi

# --- Vim Mode (zsh-vi-mode) ---
# Better Vim modal editing with adaptive cursor shapes & instant ESC
ZVM_INIT_MODE=sourcing
ZVM_KEYTIMEOUT=0.01
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# Function called after zsh-vi-mode initializes
function zvm_after_init() {
    # FZF Keybindings (Ctrl+R for history search, Ctrl+T for file search)
    [ -f "/usr/share/fzf/key-bindings.zsh" ] && source "/usr/share/fzf/key-bindings.zsh"
    [ -f "/usr/share/fzf/completion.zsh" ] && source "/usr/share/fzf/completion.zsh"
}

# Source zsh-vi-mode (AUR package or local fallback)
if [[ -f "/usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
    source "/usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
elif [[ -f "$HOME/.local/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
    source "$HOME/.local/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
else
    bindkey -v
fi

# --- Zsh Syntax Highlighting (load after vi-mode) ---
if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --- Prompt & Integrations ---
# Zoxide (smarter cd)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Starship prompt
command -v starship &>/dev/null && eval "$(starship init zsh)"

# --- Functions ---
# Aliases live in ~/.config/aliasrc (sourced at the bottom of this file).

# Yazi working directory change on exit
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Quick background job resume
function fg() {
    if [[ $# -eq 1 && $1 = - ]]; then
        builtin fg %-
    else
        builtin fg %"$@"
    fi
}

# Load custom user shortcuts and aliases if present
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
