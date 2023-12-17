zstyle :omz:plugins:ssh-agent identities github id_rsa
#ZSH_CUSTOM=$HOME/.config/zsh/custom
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#Add Cargo to system PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.fzf/bin:$HOME/.cargo/bin

AUTO_LS_COMMANDS=("/usr/bin/ls -Fa --color=always")
ZSH_THEME="powerlevel10k/powerlevel10k"

# PLUGINS
plugins=(vi-mode fzf ssh-agent gitfast dirhistory docker docker-compose history-substring-search rsync sudo zoxide)

source $ZSH/oh-my-zsh.sh

#ALIASES

# Shortcuts
alias fs="df -h | rg -v /var/lib/docker"
alias vi="nvim"
alias ~="cd ~"
alias ls="exa -alFG --sort=name --color=always"
alias l="exa -alF --sort=name --color=always|bat"
alias dv="cd /var/lib/docker/volumes/"
alias dc="docker-compose"
alias cat="bat"
alias top="btop"
alias zshrc='nvim ~/.config/zsh/.zshrc'
alias vimrc="nvim ~/.config/nvim/init.vim"
#alias lsof="lsof -nP -iTCP -sTCP:LISTEN"
alias grep="rg --smart-case -uu"
alias dock="cd ~/docker/"
alias du="duf --hide special"
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

#Auto-ls
function autols() {
  emulate -L zsh
  ls
}
if [[ ${chpwd_functions[(r)autols]} != "autols" ]];then
  chpwd_functions=(${chpwd_functions[@]} "autols")
fi

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";

	zippedSize=$(
		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
    echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
	);

}

# ENV
# Preferred editor for local and remote sessions
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nvim'
  else
    export EDITOR='nvim'
  fi

#New line afer command execution
precmd() { print "" }   
export FZF_DEFAULT_COMMAND='rg / --files --hidden --files-with-matches --fixed-strings'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS="--exact --preview 'bat --style numbers,changes --color=always {} | head -500'"
export FZF_ALT_C_COMMAND='find / -type d'
export FZF_ALT_C_OPTS='--exact'
export BAT_THEME='gruvbox-dark'
export BAT_PAGER="less -R -E -X -F"

#

 #To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
 #
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

#set ssh_auth_sock so cron can use it by calling this file and creating a var in crontab
test $SSH_AUTH_SOCK && ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-cron"
