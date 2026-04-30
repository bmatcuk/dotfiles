return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      -- Use mocha base, overlays, and surfaces with frappe style
      local mocha = require("catppuccin.palettes").get_palette "mocha"

      require("catppuccin").setup({
        flavour = "frappe",
        auto_integrations = true,
        color_overrides = {
          frappe = {
            overlay2 = mocha.overlay2,
            overlay1 = mocha.overlay1,
            overlay0 = mocha.overlay0,
            surface2 = mocha.surface2,
            surface1 = mocha.surface1,
            surface0 = mocha.surface0,
            base = mocha.base,
            mantle = mocha.mantle,
            crust = mocha.crust,
          },
        },
      })

      vim.cmd.colorscheme "catppuccin-nvim"
    end,
  },
}
