# ZSH GUARD - Exit if not running zsh interactively
[[ $- != *i* ]] && return

# ~/.zshrc: executed by zsh for interactive shells

# History configuration
HISTSIZE=1000
SAVEHIST=2000
HISTFILE=~/.zsh_history

# History options (equivalent to bash HISTCONTROL=ignoreboth)
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_IGNORE_DUPS         # Don't record duplicate commands
setopt APPEND_HISTORY           # Append to history file
setopt INC_APPEND_HISTORY       # Write to history immediately

# Enable extended globbing (equivalent to shopt -s globstar)
setopt EXTENDED_GLOB

# Check window size after each command (equivalent to shopt -s checkwinsize)
# This is handled automatically by zsh

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in prompt)
if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [[ -n "$force_color_prompt" ]]; then
    if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Load colors for zsh
autoload -U colors && colors

# Set prompt based on color support
if [[ "$color_prompt" = yes ]]; then
    PROMPT='${debian_chroot:+($debian_chroot)}%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}$ '
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    precmd() {
        print -Pn "\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a"
    }
    ;;
esac

# Enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -r ~/.dircolors ]]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Some more ls aliases
alias v="nvim"
alias ls="eza --icons --group-directories-first -a"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cdh="cd ~"
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias zshrc="v ~/.zshrc"
alias sz="source ~/.zshrc"
alias bashrc="v ~/.bashrc"
alias sb="source ~/.bashrc"
alias starship.toml="v ~/.config/starship/starship.toml"
alias ssh.config="v ~/.ssh/config"
alias etc.hosts="v /etc/hosts"
alias ssh.key="ssh-keygen -t ed25519 -C" # Add email afterwards
alias vpn="pritunl-client-electron"
alias git.init.p="~/.config/scripts/git-init.sh --personal" # followed by repo-name
alias git.init.w="~/.config/scripts/git-init.sh --work" # followed by repo-name
alias git.init.s="~/.config/scripts/git-init.sh --seizeum" # followed by repo-name
alias code="flatpak run com.visualstudio.code" # Vscode Alias
alias workplace="cd ~/dev/Workplace/"
alias lfx="cd ~/dev/Workplace/LFX"

# Add an "alert" alias for long running commands. Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(fc -ln -1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
if [[ -f ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi

# Load Cargo environment if it exists
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# Enable completion system
autoload -Uz compinit
compinit

# Enable bash completion compatibility (only if needed)
autoload -U +X bashcompinit && bashcompinit

# Load zsh completions if available (preferred over bash completions)
if [[ -d /usr/share/zsh/site-functions ]]; then
    fpath=(/usr/share/zsh/site-functions $fpath)
fi

if [[ -d /usr/share/zsh/functions/Completion ]]; then
    fpath=(/usr/share/zsh/functions/Completion $fpath)
fi

# Only load bash completions if zsh equivalents aren't available
# and only for specific tools that need it
if [[ -f /usr/share/bash-completion/completions/git ]] && ! command -v _git >/dev/null 2>&1; then
    source /usr/share/bash-completion/completions/git
fi

# Starship prompt (this will override the PROMPT set above)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Golang
export PATH=$PATH:/usr/local/go/bin

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# local binary folder -> Path
export PATH="/home/psychopunk_sage/.local/bin:$PATH"
