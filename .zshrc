# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export GPG_TTY="$(tty)"
gpg-connect-agent /bye
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"

function ykman() {
    local SCDAEMON_CONF="$HOME/.gnupg/scdaemon.conf"
    [[ -e "$SCDAEMON_CONF" ]] && rm "$SCDAEMON_CONF" && pkill gpg-agent
    command ykman $*
    [[ ! -e "$SCDAEMON_CONF" ]] && echo "disable-ccid" > "$SCDAEMON_CONF" && pkill gpg-agent
}

# If using tramp emacs over ssh don't do anything
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# Inside emacs vterm fix clear issues
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt no_share_history

export FZF_BASE="$(fzf-share)"

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:$HOME/.cargo/bin/

# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"

# change term to more cummon value support by SSH and tmux and other tools
export TERM=xterm-256color

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions nvm zsh-z 
    zsh-syntax-highlighting mvn sudo 
    docker docker-compose
    zsh-completions common-aliases 
    alias-tips fzf zsh-fzf-history-search
    emacs)

source $ZSH/oh-my-zsh.sh
source ~/.aliasrc.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/.insulter.sh ]] || source ~/.insulter.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#autoload -Uz compinit; compinit;
#bindkey "^ " _expand_alias
#zstyle ':completion:*' completer _expand_alias _complete _ignored
#zstyle ':completion:*' regular true

# Disable error on shell output during start
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Add key to ssh-agent if not already in
# ssh-add -l | grep cvy7aO9eIJK1oj5dz+2VAfXB51gI8MdritXZh/WsCPs --color="never" &> /dev/null || ssh-add

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /home/$USER/.config/broot/launcher/bash/br
