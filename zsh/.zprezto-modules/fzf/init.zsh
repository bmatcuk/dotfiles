#
# Loads fzf
#
# Authors:
#   Bob Matcuk
#

if [[ ! -o interactive ]]; then
  return 1
fi

# Load dependencies.
pmodload 'helper'

# Return if requirements are not found.
if ! is-darwin && ! is-linux; then
  return 1
fi

#
# Variables
#

# Frappe theme with the mocha bg
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#1E1E2E,spinner:#F2D5CF,hl:#E78284 \
--color=fg:#C6D0F5,header:#E78284,info:#CA9EE6,pointer:#F2D5CF \
--color=marker:#BABBF1,fg+:#C6D0F5,prompt:#CA9EE6,hl+:#E78284 \
--color=selected-bg:#51576D \
--color=border:#737994,label:#C6D0F5 \
--style minimal \
--height 20% \
--no-mouse \
--bind='ctrl-o:execute(vim {})+abort,ctrl-p:toggle-preview,ctrl-d:preview-page-down,ctrl-u:preview-page-up' \
--no-border \
--preview='bat --color always {}' \
--preview-window='right:hidden'"
export FZF_DEFAULT_COMMAND='(git ls-files -co --exclude-standard || fd -tf -tl) 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_DIR_COMMANDS='cd pushd rmdir fd rg'
function _fzf_compgen_path {
  (git ls-files -co --exclude-standard -- "$1" || fd -HL -tf -tl -td --exclude '.git' . "$1") 2> /dev/null
}

function _fzf_compgen_dir {
  fd -HL -td --exclude '.git' . "$1" 2> /dev/null
}

# Load fzf shellenv into the shell session.
if (( $+commands[fzf] )); then
  cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/fzf-shellenv-cache.zsh"
  if [[ "$commands[fzf]" -nt "$cache_file" \
      || "${ZDOTDIR:-$HOME}/.zpreztorc" -nt "$cache_file" \
      || ! -s "$cache_file" ]]; then
    mkdir -p "$cache_file:h"
    # Cache the result.
    fzf --zsh >! "$cache_file" 2> /dev/null
  fi

  source "$cache_file"
  unset cache_file
fi

bindkey "ç" fzf-cd-widget
