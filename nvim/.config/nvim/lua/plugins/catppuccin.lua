return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      local mocha = require("catppuccin.palettes").get_palette "mocha"

      require("catppuccin").setup({
        flavour = "frappe",
        auto_integrations = true,
        color_overrides = {
          frappe = {
            base = mocha.base,
          },
        },
      })

      vim.cmd.colorscheme "catppuccin-nvim"
    end,
  },
}
