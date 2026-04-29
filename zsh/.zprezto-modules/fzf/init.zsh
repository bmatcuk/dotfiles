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

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4 \
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
