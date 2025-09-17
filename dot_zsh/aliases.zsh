#------------------------------------------------------------------------------
# Aliases
#------------------------------------------------------------------------------

# Navigation
# -----------------------------------------------------------------------------
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# File System
# -----------------------------------------------------------------------------
# Use eza as a modern replacement for ls, with a fallback to the standard ls.
if command -v eza &>/dev/null; then
  alias ls='eza -lh --group-directories-first --icons'
  alias lsa='eza -lha --group-directories-first --icons' # List all files
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='eza --tree --level=2 --long --icons --git -a'
else
  alias ls='ls -lh --color=auto'
  alias lsa='ls -lha --color=auto' # List all files
  alias lt='ls -lhR --color=auto'
  alias lta='ls -lhaR --color=auto'
fi

# Fuzzy find with fzf and bat for preview
if command -v fzf &>/dev/null && command -v bat &>/dev/null; then
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
fi

# Use fd as a replacement for find
if command -v fdfind &>/dev/null; then
  alias fd='fdfind'
fi

# Git
# -----------------------------------------------------------------------------
# Note: Many git aliases are provided by the oh-my-zsh git plugin.
# These are custom additions or overrides.
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'

# System & Utilities
# -----------------------------------------------------------------------------
alias c='clear'
alias x='exit'
alias reload='source ~/.zshrc'
alias tmux='tmux -u' # Start tmux with UTF-8 support
alias vim='nvim'
alias inv='nvim $(fzf -m --preview="bat --color=always {}")' # Open file in nvim using fzf
alias cpumon='watch cat /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq'

# Package Managers (OS-specific)
# -----------------------------------------------------------------------------
# These aliases are for different Linux distributions.
# Consider loading them conditionally based on the OS.
alias dnfu='sudo dnf up --refresh' # Fedora/CentOS
alias pacup='sudo pacman -Syu'     # Arch Linux

# Misc
# -----------------------------------------------------------------------------
alias dload='aria2c -x16 -j16 -s16 -c' # Accelerated download
alias decompress="tar -xzf"
alias init3='sudo systemctl set-default multi-user.target'
alias init5='sudo systemctl set-default graphical.target'
