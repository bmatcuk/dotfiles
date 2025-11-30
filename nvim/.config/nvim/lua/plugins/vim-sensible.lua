return {
  {
    "tpope/vim-sensible",
    lazy = false,
    priority = 999,
    config = function()
      vim.o.tabstop = 2
      vim.o.expandtab = true
      vim.o.shiftwidth = 2
      vim.o.softtabstop = 2
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.splitbelow = true
      vim.o.splitright = true
      vim.o.hidden = true
      vim.o.showmatch = true
      vim.o.hlsearch = true
      vim.o.ignorecase = true
      vim.o.smartcase = true
      vim.o.list = true
      vim.o.listchars = "tab:··,trail:␠,nbsp:⎵,extends:>,precedes:<"
      vim.o.viewoptions = "cursor,folds"
      vim.o.updatetime = 250
      vim.opt.wildignore:append { "*/.git/*", "*/tmp/*", "*.swp" }
      vim.opt.shortmess:append { c = true }
      vim.o.signcolumn = "yes"
      vim.o.showmode = false
      vim.o.showtabline = 2
      vim.o.completeopt = "menu,menuone,noselect"
      vim.o.background = "dark"
      vim.o.foldlevelstart = 99
    end,
  },
}
