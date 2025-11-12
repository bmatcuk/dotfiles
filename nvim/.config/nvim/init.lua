-- global stuff
vim.g.python3_host_prog = vim.fn.trim(vim.fn.system({ "asdf", "which", "python3" }))
vim.g.python_host_prog = vim.fn.trim(vim.fn.system({ "asdf", "which", "python2" }))

vim.g.mapleader = ","



-- stop highlighting the search term on <leader>/
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", {
  desc = "Clear the search highlight.",
  silent = true,
})

-- neovim maps Y to y$, but I can't undo years of muscle memory
vim.keymap.del({ "n", "v", "o" }, "Y")

-- When using C-u or C-w to delete the line/last word in insert mode, start a
-- new change as far as undo is concerned (so you can press esc u to undo)
vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>", {
  desc = "Start a new change with C-u in insert mode.",
})
vim.keymap.set("i", "<C-w>", "<C-g>u<C-w>", {
  desc = "Start a new change with C-w in insert mode.",
})

-- highlight current match with *, rather than moving to the next match
vim.keymap.set("n", "*", ":let @/='\\<'.expand('<cword>').'\\>' <BAR> set hls <CR>", {
  desc = "Highlight current match with *, but don't move.",
  silent = true,
})
vim.keymap.set("n", "g*", ":let @/=expand('<cword>') <BAR> set hls <CR>", {
  desc = "Highlight current match with g*, but don't move.",
  silent = true,
})




local myautogroup = vim.api.nvim_create_augroup("myautogroup", { clear = true })

-- resize all windows to be roughly even when terminal window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  command = "wincmd =",
  group = myautogroup,
})

-- return cursor position after loading a file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  command = 'silent! normal! g`"zv',
  group = myautogroup,
})

-- highlight yanked text for a moment
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  command = "silent! lua vim.highlight.on_yank()",
  group = myautogroup,
})

-- no backups for crontabs
vim.api.nvim_create_autocmd({ "filetype" }, {
  pattern = "crontab",
  command = "setlocal nobackup nowritebackup",
  group = myautogroup,
})

-- don't expand tabs in go
vim.api.nvim_create_autocmd({ "filetype" }, {
  pattern = "go",
  command = "setlocal noexpandtab",
  group = myautogroup,
})

-- sync syntax highlighting when entering a buffer
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   command = ":syntax sync fromstart",
--   group = myautogroup,
-- })



-- load lazy.nvim
require("config.lazy")
