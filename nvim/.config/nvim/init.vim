" Recommended nvim 0.8.0+ (brew install --HEAD neovim)
"
" Install vim-plug first: https://github.com/junegunn/vim-plug
" Then start nvim with:
"   nvim +PlugInstall +UpdateRemotePlugins
call plug#begin('~/.config/nvim/plugged')
" general plugins
Plug 'tpope/vim-sensible'
Plug 'guns/xterm-color-table.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" added functionality
Plug 'mhinz/vim-startify'
Plug 'Olical/vim-enmasse'
Plug 'dstein64/vim-win'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-icons'
Plug 'kristijanhusak/defx-git'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" editing
Plug 'vim-scripts/restore_view.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'sheerun/vim-polyglot'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'honza/vim-snippets'
Plug 'unblevable/quick-scope'
call plug#end()

" pip3 install pynvim
let g:python3_host_prog='/usr/local/opt/python/bin/python3'
let g:python_host_prog='/usr/local/bin/python'

set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2
set number
set relativenumber
set splitbelow
set splitright
set hidden
set showmatch
set hlsearch
set ignorecase
set smartcase
set list
set listchars=tab:··,trail:␠,nbsp:⎵,extends:>,precedes:<
set viewoptions=cursor,folds
set updatetime=250
set wildignore+=*/.git/*,*/tmp/*,*.swp
set shortmess+=c
set signcolumn=yes
set noshowmode
set showtabline=2
set completeopt=menu,menuone,noselect
autocmd VimResized * wincmd =

set background=dark
colorscheme nord

let mapleader=","
nnoremap <silent> <leader>/ :nohlsearch<CR>

" neovim maps Y to y$, but I can't undo years of muscle memory
unmap Y

" brew install fzf
nnoremap <C-p> :Files<CR>
nnoremap <silent> <leader>be :<C-u>Buffers<CR>
let g:fzf_layout = { 'down': '~30%' }

" brew install ripgrep
if executable('rg')
  command! -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview({'options': '--nth=4.. --delimiter=:'}, 'right:50%:nohidden'),
    \   0)

  " :grep! --args query
  set grepprg=rg\ --vimgrep
  let g:rg_derive_root = 1
  nnoremap \ :Rg<CR>
  nnoremap <leader>\ :Rg <C-r><C-w><CR>
endif
augroup mylocquickcmds
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END

" lightline settings
let g:lightline#bufferline#unicode_symbols=1
let g:lightline#bufferline#unnamed='[No Name]'
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'active': {
    \ 'left': [
      \ ['mode', 'paste'],
      \ ['git'],
      \ ['readonly', 'filename', 'currentfunc']
    \ ],
    \ 'right': [
      \ ['fileencodingandformat', 'percent', 'line', 'column'],
      \ ['filetype'],
      \ ['lspstatus', 'lspwarning', 'lsperror']
    \ ]
  \ },
  \ 'inactive': {
    \ 'left': [['relativepath']],
    \ 'right': [
      \ ['fileencodingandformat', 'percent', 'line', 'column'],
      \ ['filetype']
    \ ]
  \ },
  \ 'tabline': {
    \ 'left': [['buffers']],
    \ 'right': []
  \ },
  \ 'component': {
    \ 'column': '%v',
    \ 'filename': '%t%m',
    \ 'fileencodingandformat': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
    \ 'line': '%l/%L ',
    \ 'paste': '[%{&paste?"PASTE":""}]',
    \ 'percent': '%3p%% ☰',
    \ 'relativepath': '%f%m'
  \ },
  \ 'component_function': {
    \ 'currentfunc': 'LightlineCurrentFunc',
    \ 'git': 'LightlineGitStatus',
    \ 'readonly': 'LightlineReadonly'
  \ },
  \ 'component_expand': {
    \ 'buffers': 'lightline#bufferline#buffers',
    \ 'lsperror': 'LightlineLspError',
    \ 'lspwarning': 'LightlineLspWarning',
    \ 'lspstatus': 'LightlineLspStatus',
  \ },
  \ 'component_type': {
    \ 'buffers': 'tabsel',
    \ 'lsperror': 'error',
    \ 'lspwarning': 'warning'
  \ }
\}

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction
function! LightlineGitStatus()
  let l:branch = get(b:, 'git_branch_status', '')
  if empty(l:branch)
    return ''
  endif
  return ' '.l:branch
endfunction
function! LightlineCurrentFunc()
  let l:func = get(b:, 'lsp_current_function', '')
  if empty(l:func)
    return ''
  endif
  return '('.l:func.')'
endfunction
function! s:lightline_lsp_diagnostic(severity, sign) abort
  let l:count = luaeval("#vim.diagnostic.get(0, { severity = _A })", a:severity)
  if l:count == 0
    return ''
  endif
  return a:sign.' '.l:count
endfunction
function! LightlineLspError()
  return s:lightline_lsp_diagnostic(luaeval('vim.diagnostic.severity.ERROR'), '✗')
endfunction
function! LightlineLspWarning()
  return s:lightline_lsp_diagnostic(luaeval('vim.diagnostic.severity.WARN'), '◆')
endfunction
function! LightlineLspStatus()
  return luaeval("require'lsp-status/statusline'.progress()")
endfunction

" update colors for lightline errors and warnings
function! s:patch_lightline_colorscheme() abort
  try
    let l:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette

    let l:palette.normal.error[0][2] = l:palette.normal.error[0][3]
    let l:palette.normal.error[0][3] = '0'
    let l:palette.normal.warning[0][2] = l:palette.normal.warning[0][3]
    let l:palette.normal.warning[0][3] = '0'
  catch
  endtry
endfunction
call s:patch_lightline_colorscheme()

augroup mylightline
  autocmd!
  autocmd ColorScheme * call s:patch_lightline_colorscheme()
augroup END

" seems to be some sort of weird loop going on with lightline which causes
" switching buffers to be slow, and it gets worse as time goes on... I have no
" idea what problems this fix might cause...
autocmd VimEnter * autocmd! lightline SessionLoadPost

" execute macros over a visual selection with @x where x = macro register
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" highlight current match with *, rather than moving to the next match
nnoremap <silent> * :let stay_star_view = winsaveview()<CR>*:call winrestview(stay_star_view)<CR>

" defx
nnoremap <silent> <leader>e :Defx `expand('%:p:h')` -search=`expand('%:p')` -columns='indent:git:icons:filename:type' -split=vertical -winwidth=50 -direction=topleft<CR>
augroup mydefx
  autocmd!
  autocmd FileType defx call s:defx_my_settings()
augroup END
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ defx#is_directory() ?
        \ defx#do_action('open') :
        \ defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> v
        \ defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o
        \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> ;
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> <BS>
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
endfunction

" startify
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

" vim-win - <leader>w will enter vim-win 'mode'; <space>w will exit vim-win
" after just one command: this is useful if all you want to do is switch which
" window is active. I've also mapped '-' to one-command-mode because I'm used
" to using it with my previous solution (choosewin).
nnoremap <silent> <space>w :<C-u>Win 1<CR>
nnoremap <silent> - :<C-u>Win 1<CR>

" gitgutter
nmap <silent> ]h <Plug>(GitGutterNextHunk)
nmap <silent> [h <Plug>(GitGutterPrevHunk)

" lsp
lua << EOL
require'mason'.setup()
require'mason-lspconfig'.setup {
  automatic_installation = { exclude = { "zls" } }
}

local lspstatus = require('lsp-status')
lspstatus.config { show_filename = false }
lspstatus.register_progress()

local lspconfig = require('lspconfig')
local capabilities = vim.tbl_deep_extend(
  'keep',
  require'cmp_nvim_lsp'.default_capabilities(),
  lspstatus.capabilities,
  vim.lsp.protocol.make_client_capabilities()
)

-- npm i -g vscode-langservers-extracted
lspconfig.html.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach
}
lspconfig.cssls.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach,
  settings = {
    css = { validate = false },
    less = { validate = false },
    scss = { validate = false }
  }
}
lspconfig.jsonls.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach
}
lspconfig.eslint.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach
}

-- npm i -g typescript typescript-language-server
lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach
}

-- npm i -g stylelint-lsp
lspconfig.stylelint_lsp.setup{
  capabilities = capabilities,
  on_attach = lspstatus.on_attach,
  settings = {
    stylelintplus = {
      autoFixOnFormat = true
    }
  }
}

lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach
}
lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach
}
lspconfig.dartls.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach
}

lspconfig.zls.setup {
  capabilities = capabilities,
  on_attach = lspstatus.on_attach
}
EOL

" lsp related colors
hi default link LspReferenceText CursorColumn
hi default link LspReferenceRead LspReferenceText
hi default link LspReferenceWrite LspReferenceText

" lsp - navigate diagnostics
nnoremap <silent> [d :call v:lua.vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d :call v:lua.vim.diagnostic.goto_next()<CR>
nmap <silent> <space>d :call v:lua.vim.diagnostic.open_float({'focusable':0,'close_events':['CursorMoved','CursorMovedI','BufHidden','InsertCharPre','WinLeave']})<CR>

" lsp - navigation and information
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call v:lua.vim.lsp.buf.hover()
  endif
endfunction

nnoremap <silent> <space>D :call v:lua.vim.lsp.buf.type_definition<CR>
nnoremap <silent> gD :call v:lua.vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd :call v:lua.vim.lsp.buf.definition()<CR>
nnoremap <silent> <C-K> :call v:lua.vim.lsp.buf.signature_help()<CR>
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gi :call v:lua.vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr :call v:lua.vim.lsp.buf.references()<CR>

augroup mylsp
  autocmd!

  "highlight symbol under cursor on CursorHold
  autocmd CursorHold <buffer> silent! lua vim.lsp.buf.document_highlight()
  autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved <buffer> silent! lua vim.lsp.buf.clear_references()
augroup END

" lsp - make changes
nnoremap <silent> <leader>rn :call v:lua.vim.lsp.buf.rename()<CR>
nnoremap <silent> <space>ca :call v:lua.vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>f :call v:lua.vim.lsp.buf.format()<CR>

" lsp - changes to a range
xnoremap <silent> <leader>f :call v:lua.vim.lsp.buf.range_formatting()<CR>
xnoremap <silent> <space>ca :call v:lua.vim.lsp.buf.range_code_action()<CR>

" format entire file using :Format
command! -nargs=0 Format :call v:lua.vim.lsp.buf.format()<CR>

" completion
lua << EOL
local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#jumpable'](1) == 1 then
        feedkey("<Plug>(vsnip-jump-next)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm()
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp', max_item_count = 5 },
    { name = 'path', max_item_count = 5 }
  }, {
    { name = 'buffer', max_item_count = 5 }
  })
}

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer', max_item_count = 5 }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path', max_item_count = 5 }
  }, {
    { name = 'cmdline', max_item_count = 5 }
  })
})
EOL

" filetype-specific
augroup myfilespecific
  autocmd!
  autocmd filetype crontab setlocal nobackup nowritebackup
  autocmd filetype go setlocal noexpandtab
  autocmd BufEnter * :syntax sync fromstart
augroup END

if &diff
  map <leader>1 :diffget LOCAL<cr>
  map <leader>2 :diffget BASE<cr>
  map <leader>3 :diffget REMOTE<cr>
endif

" vim-polyglot will only set the filetype to glsl if the file extension is
" .frag and the file has some glsl-looking stuff.
au BufRead,BufNewFile *.frag set filetype=glsl

" When using C-u or C-w to delete the line/last word in insert mode, start a
" new change as far as undo is concerned (so you can press esc u to undo)
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

function! s:update_git_branch_status(path)
  let l:lines = systemlist('git -C "'.a:path.'" status -bs --porcelain 2>/dev/null')
  let l:status = ''
  if len(l:lines) > 0
    let l:status = matchstr(l:lines[0], '\v## \zs\w+\ze(...|$)')
    if match(l:lines, '\v^\s*M') >= 0
      let l:status = l:status.'*'
    endif
    if match(l:lines, '\v^\s*A') >= 0
      let l:status = l:status.'+'
    endif
    if match(l:lines, '\v^\s*D') >= 0
      let l:status = l:status.'-'
    endif
  endif
  let b:git_branch_status = l:status
endfunction

augroup gitbranchstatus
  autocmd!
  autocmd BufNewFile,BufReadPost,BufWritePost * call s:update_git_branch_status(expand('<amatch>:p:h'))
  autocmd BufEnter * call s:update_git_branch_status(expand('%:p:h'))
augroup END

" return cursor position after loading a file
autocmd BufReadPost * silent! normal! g`"zv

" highlight yanked text
au TextYankPost * silent! lua vim.highlight.on_yank()

" rainbow settings
let g:rainbow_active = 1
let g:rainbow_conf = {
\       'guifgs': ['#df0000', '#df5f00', '#dfdf00', '#00af00', '#005fff', '#5f00ff', '#8700df'],
\       'ctermfgs': ['160', '166', '184', '34', '27', '57', '92'],
\       'operators': '_,_',
\       'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\       'separately': {
\               '*': {},
\               'tex': {
\                       'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\               },
\               'vim': {
\                       'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\               },
\               'xml': {
\                       'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\               },
\               'xhtml': {
\                       'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\               },
\               'html': {
\                       'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\               },
\               'php': {
\                       'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold', 'start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop'],
\               },
\               'css': 0,
\       }
\}

" load local config
runtime local.vim
