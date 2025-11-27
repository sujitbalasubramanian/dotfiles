# Exit if not running interactively
[[ $- != *i* ]] && return

# History settings
setopt appendhistory inc_append_history hist_ignore_dups hist_ignore_space autocd
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/history

# Prompt and Git branch info
autoload -U colors vcs_info
colors
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' g:(%b)'
setopt prompt_subst
PS1='%B%{$fg[blue]%}%1d%{$fg[yellow]%}${vcs_info_msg_0_}%{$reset_color%}~> %b'

# Custom functions
fpath+=(${ZDOTDIR:-~}/.zsh_functions)
fpath+=(${ZDOTDIR:-~}/comp)

# Completion
autoload -U compinit
zmodload zsh/complist
compinit
zstyle ':completion:*' menu select
_comp_options+=(globdots)

# Vi mode + cursor shape
bindkey -v
export KEYTIMEOUT=1
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^?' backward-delete-char

function zle-keymap-select {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;
        viins|main) echo -ne '\e[5 q';;
    esac
}
function zle-line-init {
    zle -K viins
    echo -ne '\e[5 q'
}
zle -N zle-keymap-select
zle -N zle-line-init
preexec() { echo -ne '\e[5 q' }
echo -ne '\e[5 q'

# Ctrl+E to open command in Vim
autoload edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# fzf
if command -v fzf >/dev/null; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

# External configs
[[ -f "$XDG_CONFIG_HOME/shell/alias" ]] && source "$XDG_CONFIG_HOME/shell/alias"
[[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f "/usr/share/nvm/init-nvm.sh" ]] && source /usr/share/nvm/init-nvm.sh

# Tools
eval "$(pyenv init -)"
