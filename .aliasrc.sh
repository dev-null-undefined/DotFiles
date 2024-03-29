alias gen-pass="date +%s | sha256sum | base64 | head -c 32 ; echo"

alias code-with-me='nix-autobahn-fhs-shell libzip xorg.libXext xorg.libX11 xorg.libXrender xorg.libXtst xorg.libXi freetype jetbrains.jdk libdbusmenu python3 fontconfig glibc'

alias config='git --git-dir=$HOME/GitHub/Martin/DotFiles/.git --work-tree=$HOME'
alias config-st='config status --untracked-files=no'
alias config-c='config commit --untracked-files=no'
alias config-a='config add'

alias gppo='g++ --std=c++17 -Wall -pedantic -Wno-long-long -g -fno-omit-frame-pointer -Wunused-variable -Wtrigraphs -trigraphs -O0'
alias gpp='g++ --std=c++17 -Wall -pedantic -Wno-long-long -g -fno-omit-frame-pointer -Wunused-variable -Wtrigraphs -trigraphs -O2'

alias kill-window='xprop _NET_WM_PID | sed "s/.*=//g" | xargs kill -9'

export NIXOS_CONFIG_DIR="/etc/nixos"

sudo-nom-rebuild-fallback() {
    if ! command -v nom-rebuild &> /dev/null
    then
	sudo nixos-rebuild "$@"
    else
	sudo nom-rebuild "$@"
    fi
}


btrfs-tree() {
    sudo btrfs subvol list / | cut -f9 -d' ' | sed -e 's/^/ROOT\//' | ~/scripts/paths2indent | ~/scripts/indent2tree
}

nix-update() {
    sudo nix flake update "$NIXOS_CONFIG_DIR"
    if [ $? -eq 0 ]; then
	nix-rebuild
    	if [ $? -eq 0 ]; then
	    git --git-dir="${NIXOS_CONFIG_DIR}/.git" --work-tree="$NIXOS_CONFIG_DIR" add "${NIXOS_CONFIG_DIR}/flake.lock"
	fi
    fi
}

nix-rebuild() {
    sudo-nom-rebuild-fallback switch --flake "${NIXOS_CONFIG_DIR}#"
}

nix-rebuild-boot () {
    sudo-nom-rebuild-fallback boot --flake "${NIXOS_CONFIG_DIR}#"
}

nix-find() {
    nix eval "${NIXOS_CONFIG_DIR}#nixosConfigurations.$(hostname).pkgs.$1.outPath"
}

nix-path() {
    nix-find "$1"
}

nix-pkg() {
    pkgs=()
    hostname=$(hostname)

    while (($#))
    do
	pkg="$1"

	shift
	
	if [[ "$pkg" == "--" ]]; then
		break
	fi

	pkgs+=("${NIXOS_CONFIG_DIR}#nixosConfigurations.${hostname}.pkgs.${pkg}")
    done

    if [ $# -gt 0 ]; then
	nix shell "${pkgs[@]}" -c "${@}"
    else
	nix shell "${pkgs[@]}"
    fi
}

alias du='ncdu'
alias df='duf'
alias ps='procs'
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

gdb-clear () {
    rm -rf ~/.gdbinit
}

gdb-peda() {
    gdb-clear
    ln -s /home/martin/.gdb-configs/peda/pedainit /home/martin/.gdbinit
    gdb "$@"
}

gdb-dash() {
    gdb-clear
    ln -s /home/martin/.gdb-configs/dashboard.py /home/martin/.gdbinit
    gdb "$@"
}

gdb-gef() {
    gdb-clear
    ln -s /home/martin/.gdb-configs/gef.py /home/martin/.gdbinit
    gdb "$@"
}

ngrep() {
	sgrep "$*" "$NIXOS_CONFIG_DIR"
}

nvidia-offload() {
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
}

gppa() {
    gpp -o /tmp/a.out "$@" || return 1
    /tmp/a.out
}

vimg() {
    vim "$1"
    gpp -o /tmp/a.out "$1" || return 1
    shift 1
    /tmp/a.out "$@"
}

alias ssh-key="ssh -i ~/.ssh/OpenSSH_key "
alias ssh-pie="ssh-key root@10.8.0.2"
#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
alias ls='lsd'
alias l='lsd -Fh'     #size,show type,human readable
alias la='lsd -AFh'   #long list,show almost all,show type,human readable
alias lla='lsd -lAFh'   #long list,show almost all,show type,human readable
alias ll='lsd -lh'      #long list
alias ldot='lsd -hld .*'

alias cat='bat -p '

alias -g N='| /home/martin/GitHub/no-more-secrets/bin/nms'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkd='mkdir -pv'


n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@" -deHa

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}


alias mysql="mycli -u root"

alias sc="systemctl"

alias fun="lolcat"

fuck () {
    TF_PYTHONIOENCODING=$PYTHONIOENCODING;
    export TF_SHELL=zsh;
    export TF_ALIAS=fuck;
    TF_SHELL_ALIASES=$(alias);
    export TF_SHELL_ALIASES;
    TF_HISTORY="$(fc -ln -10)";
    export TF_HISTORY;
    export PYTHONIOENCODING=utf-8;
    TF_CMD=$(
        thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@
    ) && eval $TF_CMD;
    unset TF_HISTORY;
    export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
    test -n "$TF_CMD" && print -s $TF_CMD
}

alias j="z"
alias f="fuck"
alias svim="sudoedit"

alias ggit="cd ~/Git && tree -L 2"
alias ei3="vim ~/.config/i3/config"
alias eai3statu-rs="vim ~/.config/i3status-rust/config.toml"
alias ealacritty="vim ~/.config/alacritty/alacritty.yml"

function cs {
    	if [[ $# -gt 1 ]] && [[ "$2" == "sudo" ]]
	then
	    if sudo test -f "$1"
	    then
		sudo cat "$1"
	    else
		sudo ls "${1:-.}"	
	    fi
	else
	    if [ -f "$1" ]
	    then
		cat "$1"
	    else
		ls "${1:-.}"	
	    fi
	fi
}
