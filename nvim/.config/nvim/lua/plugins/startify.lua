return {
  {
    "mhinz/vim-startify",
    lazy = false,
    priority = 900,
    config = function()
      vim.cmd [[
        function! s:startifyGitModified()
          let files = systemlist('git ls-files -m 2>/dev/null')
          return map(files, "{'line': v:val, 'path': v:val}")
        endfunction
        function! s:startifyGitUntracked()
          let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
          return map(files, "{'line': v:val, 'path': v:val}")
        endfunction

        let g:startify_session_persistence = 1
        let g:startify_change_to_vcs_root = 1
        let g:startify_enable_special = 0
        let g:startify_change_to_dir = 0
        let g:startify_lists = [
          \ { 'header': ['   MRU '. getcwd()], 'type': 'dir'                              },
          \ { 'header': ['   Git Modified'],   'type': function('s:startifyGitModified')  },
          \ { 'header': ['   Git Untracked'],  'type': function('s:startifyGitUntracked') },
          \ { 'header': ['   Sessions'],       'type': 'sessions'                         },
        \ ]

        let g:startify_custom_header = []
        let g:startify_custom_footer = 'startify#pad(split(system("fortune -s computers linuxcookie softwareengineering | cowsay -f kitten"), "\n"))'
      ]]
    end,
}
