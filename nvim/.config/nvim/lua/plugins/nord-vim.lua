return {
  {
    "bmatcuk/nord-vim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord-vim")
      vim.cmd [[
        colorscheme nord
      ]]
    end,
  },
}
