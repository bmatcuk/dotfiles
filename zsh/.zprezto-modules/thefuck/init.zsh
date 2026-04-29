#
# Loads thefuck
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

# Load thefuck shellenv into the shell session.
if (( $+commands[thefuck] )); then
  cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/thefuck-shellenv-cache.zsh"
  if [[ "$commands[thefuck]" -nt "$cache_file" \
      || "${ZDOTDIR:-$HOME}/.zpreztorc" -nt "$cache_file" \
      || ! -s "$cache_file" ]]; then
    mkdir -p "$cache_file:h"
    # Cache the result.
    thefuck --alias >! "$cache_file" 2> /dev/null
  fi

  source "$cache_file"
  unset cache_file
fi
