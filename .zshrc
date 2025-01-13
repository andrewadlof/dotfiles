################### ZSH CONFIG ###################

# Export Statements
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EZA_COLORS="$(cat ~/.config/eza/colors.config)"

# Set FUNCNEST limit
FUNCNEST=1000

# Update OMZ without asking
zstyle ':omz:update' mode auto

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'

# Load completions
autoload -U compinit && compinit

# OMZ Plugins
plugins=(
  aliases
  command-not-found
  copyfile
  copypath
  docker
  dirhistory
  extract
  fzf
  fzf-tab
  git
  node
  python
  tmux
  vscode
  sudo
  z
  zsh-autosuggestions
  zsh-completions
  zsh-expand
)

# Refresh OMZ
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

############ Aliases ##############
alias zshsrc="source ~/.zshrc"
alias bat="batcat"
alias winhome="cd /mnt/c/Users/Drew"

# Better directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .4='cd ../../../../'
alias ~='cd ~'

# Enhanced listing commands
alias ls="eza --header --icons --hyperlink --octal-permissions"
alias ll="eza -l --header --icons --hyperlink --octal-permissions"
alias la="eza -la --header --icons --hyperlink --octal-permissions"
alias lt="eza --tree --header --icons --hyperlink --octal-permissions"
alias dir='dir --color=auto'

# Fuzzy Find
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias fz="find . -maxdepth 1 | sed 's/^\.\///g' | fzf --preview 'fzf-previewer {}'"

# Text Editor
alias vim='nvim'
alias vi='nvim'

# Multiplexer (tmux/zellij)
alias zj='zellij'
alias za='zellij attach' # Attach session
alias zl='zellij ls' # List session
alias zk='zellij kill-session' # Kill session

# Safety nets
alias rm='rm -i'    # Prompt before removal
alias cp='cp -i'    # Prompt before overwriting
alias mv='mv -i'    # Prompt before overwriting
alias mkdir='mkdir -p'  # Create parent directories as needed

# System monitoring
alias df='df -h'     # Human-readable sizes
alias free='free -m' # Show sizes in MB
alias dus='du -sh *' # Disk usage of current directory items

# Common shortcuts
alias c='clear'
alias h='history'
alias j='jobs -l'
alias p='ps -f'
alias update='sudo apt update && sudo apt upgrade'
alias ports='netstat -tulanp'

# Network
alias myip='curl http://ipecho.net/plain; echo'
alias ping='ping -c 5'  # Ping with 5 packets only
alias fastping='ping -c 100 -s.2'

# System monitoring
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'  # Memory processes
alias pscpu='ps auxf | sort -nr -k 3'  # CPU processes

# Programming
alias python="python3.12"

# Exec Statements
eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json')"
eval "$(zoxide init zsh)"
eval $(thefuck --alias fix)
