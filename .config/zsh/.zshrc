# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# setopt
setopt appendhistory          # append to the history file, don't overwrite it
setopt INC_APPEND_HISTORY     # appends history line by line in history file
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt autocd 

#history
HISTSIZE=10000000 
SAVEHIST=10000000
HISTFILE=~/.cache/history

autoload -U colors && colors	# Load colors
autoload -Uz vcs_info
precmd() { vcs_info }
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' ( %b)'

setopt PROMPT_SUBST

PS1='%B%{$fg[green]%}➜ %{$fg[blue]%}%1d%{$fg[yellow]%}${vcs_info_msg_0_} %{$reset_color%}$ %b'

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^E' edit-command-line

#fixkey delete,end,home 
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

fpath+=${ZDOTDIR:-~}/.zsh_functions

#fzf completion
if [ -x "$(command -v fzf)"  ]
then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

#shell alias
[ -f "${XDG_CONFIG_HOME}/shell/alias" ] && source $XDG_CONFIG_HOME/shell/alias

# Load zsh syntax highlighting
[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && 
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f "/usr/share/nvm/init-nvm.sh" ] && source /usr/share/nvm/init-nvm.sh

# bun completions
[ -s "/home/sujit/.bun/_bun" ] && source "/home/sujit/.bun/_bun"

eval "$(pyenv init -)"
eval "$(zoxide init zsh)"
