# Function that echos as much of a string as possible,
# and automatically adds an ellipsis if necessary.
# It returns the length of the output
function ellipsis_echo {
  if [ ${#1} -lt $2 ]; then
    echo -en "$1"
    return ${#1}
  else
    local MAX=$(( $2 - 3 ))
    echo -en "${1:0:$MAX}..."
    return $MAX
  fi
}

# Custom command prompt shows current directory, current
# ruby/node/etc version, and current git branch
# NOTE: Requires a powerline compatible font.
function prompt {
  # -3 for the opening space, the closing space, and final hard arrow
  local WIDTH=$(( $(tput cols) - 3 ))
  local HARD_ARROW="\xEE\x82\xB0"
  local DIR=$(dirs +0)

  # determine if the directory we're in is using one of our asdf tools
  local TOOL=""
  local TOOL_ICON=""
  local DIR_PREFIX=""
  for i in $(seq 1 $(echo "$DIR"|tr -cd '/'|wc -c)); do
    if [[ -f "${DIR_PREFIX}Gemfile" ]]; then
      TOOL_ICON="\uE739"
      TOOL="ruby"
      break
    elif [[ -f "${DIR_PREFIX}package.json" ]]; then
      TOOL_ICON="\uE781"
      TOOL="nodejs"
      break
    elif [[ -f "${DIR_PREFIX}go.mod" ]]; then
      TOOL_ICON="\uE724"
      TOOL="golang"
      break
    elif [[ -f "${DIR_PREFIX}Cargo.toml" ]]; then
      TOOL_ICON="\uE7a8"
      TOOL="rust"
      break
    fi
    DIR_PREFIX="${DIR_PREFIX}../"
  done

  # blank line
  echo

  local JOBS=$(jobs -p | wc -l | tr -d '[:space:]')
  if [ "$JOBS" -gt 0 ]; then
    # subtract 4 from WIDTH for space, double hard arrow, space that separates
    # jobs count from directory
    echo -en "$(tput bold)$(tput setab 4)$(tput setaf 0) "
    ellipsis_echo "\uEf96 $JOBS" $WIDTH
    WIDTH=$(( $WIDTH - $? - 4 ))
    echo -en " $(tput sgr0)$(tput setab 0)$(tput setaf 4)$HARD_ARROW"
    echo -en "$(tput setab 6)$(tput setaf 0)$HARD_ARROW$(tput sgr0)"
  fi

  # output current directory
  # subtract 3 from WIDTH for space, hard arrow, space that separates parts
  echo -en "$(tput bold)$(tput setab 6)$(tput setaf 0) "
  ellipsis_echo "$DIR" $WIDTH
  WIDTH=$(( $WIDTH - $? - 3 ))
  echo -en " $(tput sgr0)$(tput setaf 6)"

  # tool version - also subtract 3 for space, hard arrow, space
  if [ -n "$TOOL" ]; then
    echo -en "$(tput setab 0)$HARD_ARROW $(tput setaf 7)$(tput bold)"
    ellipsis_echo "$TOOL_ICON $(asdf current $TOOL | tail -n1 | awk '{print $2}')" $WIDTH
    WIDTH=$(( $WIDTH - $? - 3 ))
    echo -en " $(tput sgr0)$(tput setaf 0)"
  fi

  # git information - also subtract 3 for space, hard arrow, space
  if [ "$(git rev-parse --is-inside-work-tree 2>&1)" == "true" ]; then
    echo -en "$(tput setab 8)$HARD_ARROW $(tput setaf 7)$(tput bold)"
    ellipsis_echo "\uE725 $(git status -bs --porcelain | awk 'NR==1{w=substr($0,4,match($0,/\.{3}|$/)-4);x=y=z=""};!x&&$1~/\?/{x="?"};!y&&$1~/M/{y="*"};!z&&$1~/[ADRCU]/{z="+"};x&&y&&z{exit};END{print z y x w}')" $WIDTH
    WIDTH=$(( $WIDTH - $? - 3 ))
    echo -en " $(tput sgr0)$(tput setaf 8)"
  fi

  # closing hard arrow
  echo -e "$HARD_ARROW$(tput sgr0)"
}
PROMPT_COMMAND=prompt
PS1="\$ "

# aliases
alias ls='ls -GFh'
alias grep='grep --line-number --color=auto'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'

# Colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export GREP_COLORS="fn=34:mt=01;34:ln=01;30:se=30"
export LESS="-FRXx2"

# dircolors - brew install coreutils
[[ -r ~/.dir_colors ]] && eval $(gdircolors ~/.dir_colors)

# history
export HISTCONTROL=ignoreboth
export HISTIGNORE="pwd:ls:ls -al:cd .."
shopt -s histappend

# lesspipe
[ -x /usr/local/bin/lesspipe.sh ] && eval "$(/usr/local/bin/lesspipe.sh)"

# Add homebrew to path
export HOMEBREW_BAT=1
export HOMEBREW_NO_GITHUB_API=1
HOMEBREW_PATHS=(
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/local/opt/grep/libexec/gnubin"
  "/usr/local/opt/findutils/libexec/gnubin"
  "/usr/local/opt/gnu-sed/libexec/gnubin"
  "/usr/local/opt/gnu-tar/libexec/gnubin"
  "/usr/local/opt/gnu-which/libexec/gnubin"
  "$PATH"
)
export PATH=$(IFS=":"; echo "${HOMEBREW_PATHS[*]}")

# Add node bin to path
export PATH=$PATH:./node_modules/.bin

# asdf - brew install asdf
# asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
# asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export NODEJS_CHECK_SIGNATURES=no
export GOPATH=$HOME/go
# . /usr/local/opt/asdf/asdf.sh
#. /usr/local/opt/asdf/libexec/asdf.sh

# brew install bat (https://github.com/sharkdp/bat)
export BAT_THEME="nord"

# fuck (https://github.com/nvbn/thefuck)
eval $(thefuck --alias)

# brew install bash-completion
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# brew install fzf (https://github.com/junegunn/fzf)
# brew install fd (https://github.com/sharkdp/fd)
export FZF_DEFAULT_OPTS='--height 20% --no-mouse --bind="ctrl-o:execute(vim {})+abort,ctrl-v:toggle-preview,ctrl-d:preview-page-down,ctrl-u:preview-page-up" --no-border --preview="bat --color always {}" --preview-window="right:hidden"'
export FZF_DEFAULT_COMMAND='(git ls-files -co --exclude-standard || fd -tf -tl) 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
function _fzf_compgen_path {
  (git ls-files -co --exclude-standard || fd -HL -tf -tl -td --exclude '.git') 2> /dev/null
}

function _fzf_compgen_dir {
  (git ls-files -co --exclude-standard || fd -HL -td --exclude '.git') 2> /dev/null
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
_fzf_setup_completion path bat tig
_fzf_setup_completion dir fd rg

# Misc
alias vi='nvim'
alias vim='nvim'
alias gr='cd $(git root)'
alias qpreview='qlmanage -p &>/dev/null'
alias preview="fzf --preview 'bat --color \"always\" {}' --preview-window :nohidden --height 100% --no-border"
export EDITOR=nvim
export VISUAL=nvim
export GPG_TTY=$(tty)

# Audio stops working on my Macbook Pro with Touchbar ALL THE DAMN TIME.
function fixaudio {
  sudo killall coreaudiod
}
export -f fixaudio

[[ -r ~/.bash_profile.local ]] && eval "$(cat ~/.bash_profile.local)"

# Start TMUX, but only if it exists, we're in an
# interactive shell, and we aren't inside tmux.
if command -v tmux >/dev/null && [[ $- == *i* && -z "$TMUX" ]]; then
  if tmux has 2>/dev/null; then exec tmux att; else exec tmux; fi
fi
