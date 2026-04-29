return {
  {
    "bmatcuk/nord-vim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme nord]]
    end,
  },
}
