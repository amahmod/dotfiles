export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export ZSH_WEB_SEARCH_ENGINES=(reddit "https://www.reddit.com/search/?q=")
export FZF_DEFAULT_COMMAND='rg --files'

ZSH_THEME="robbyrussell" # agnoster, cloud, robbyrussell

plugins=(
    git
    copypath # `copypath` <path> to copy path to clipboard
    copyfile # `copyfile` <file> to copy file to clipboard
    colorize
    colored-man-pages
    vi-mode
    archlinux
    web-search
    fzf
    jump
    aliases
    extract
    universalarchive
    zsh-interactive-cd
    zsh-navigation-tools
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

autoload znt-history-widget
zle -N znt-history-widget
bindkey "^R" znt-history-widget

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# https://stackoverflow.com/a/32614814
fg() {
    if [[ $# -eq 1 && $1 = - ]]; then
        builtin fg %-
    else
        builtin fg %"$@"
    fi
}

function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Install global npm pacakges without sudo
NPM_PACKAGES="${HOME}/.local/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

[ ! -d "~/.cargo/bin/" ] && export PATH="$PATH:${HOME}/.cargo/bin"
[ ! -d "~/go/bin/" ] && export PATH="$PATH:${HOME}/go/bin"

# bun completions
[ -s "/home/amahmod/.bun/_bun" ] && source "/home/amahmod/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Deno
export DENO_INSTALL="/home/amahmod/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Set up input method environment variables
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XMODIFIERS="@im=ibus"
