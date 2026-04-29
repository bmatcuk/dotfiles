#
# My custom aliases
#
# Author:
#   Bob Matcuk
#

# prezto's utility package includes the alias `ll` which does this, but I have
# decades of muscle memory
alias ls="${aliases[ls]:-ls} -h"

# verbose output for file operations
alias cp="${aliases[cp]:-cp} -v"
alias mv="${aliases[mv]:-mv} -v"
alias rm="${aliases[rm]:-rm} -v"

# vim - damn muscle memory!
alias vi='nvim'
alias vim='nvim'

# line numbers
alias grep="${aliases[grep]:-grep} --line-number"
