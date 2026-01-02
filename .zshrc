zstyle :omz:plugins:ssh-agent identities github id_rsa

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#Add Cargo to system PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.fzf/bin:$HOME/.cargo/bin:/opt/homebrew/bin

AUTO_LS_COMMANDS=("/usr/bin/ls -Fa --color=always")
ZSH_THEME="agnoster" # set by `omz`

# PLUGINS
plugins=(vi-mode fzf ssh-agent gitfast dirhistory docker docker-compose history-substring-search rsync sudo zoxide)

source $ZSH/oh-my-zsh.sh

#ALIASES

# Shortcuts
alias fs="df -h | rg -v /var/lib/docker"
case "$OSTYPE" in
  darwin*)
    alias vi="zed"
    alias zshrc="zed ~/.config/zsh/.zshrc"
    alias ssh="kitten ssh"
  ;;
  linux*)
    alias vi="nvim"
    alias zshrc="nvim ~/.config/zsh/.zshrc"
  ;;
esac
alias ~="cd ~"
alias ls="eza -alF --sort=name --color=always"
alias l="eza -alF --sort=name --color=always|bat"
alias dv="cd /var/lib/docker/volumes/"
alias dc="docker compose"
alias cat="bat"
alias top="btop"
alias grep="rg --smart-case -uu"
alias dock="cd ~/docker/"
#alias du="duf --hide special"
alias fstab="vi /etc/fstab"
alias sources="vi /etc/apt/sources.list"

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000000
SAVEHIST=$HISTSIZE

#vi mode bindings
export KEYTIMEOUT=1

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK 2>/dev/null
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt +o nomatch  #Auto-escape wildcards if no literal match found

# FUNCTIONS

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# ENV
# Preferred editor for local and remote sessions
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='hx'
  else
    export EDITOR='hx'
  fi

#New line afer command execution
precmd() { print "" }   
export FZF_DEFAULT_COMMAND='rg --files --hidden --files-with-matches --fixed-strings --ignore-case /'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS="--exact --preview 'bat --style numbers,changes --color=always {} | head -500'"
export FZF_ALT_C_COMMAND='find ~ -type d'
export FZF_ALT_C_OPTS='--exact'
export BAT_THEME='gruvbox-dark'
export BAT_PAGER="less -R -E -X -F"

#set ssh_auth_sock so cron can use it by calling this file and creating a var in crontab
test $SSH_AUTH_SOCK && ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-cron"
bindkey "ç" fzf-cd-widget
