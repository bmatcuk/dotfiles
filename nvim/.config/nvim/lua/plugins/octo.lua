return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = function()
      local latte = require("catppuccin.palettes").get_palette "latte"
      local frappe = require("catppuccin.palettes").get_palette "frappe"
      local mocha = require("catppuccin.palettes").get_palette "mocha"
      local colorUtils = require("catppuccin.utils.colors")

      vim.api.nvim_set_hl(0, "OctoReviewDiffAddText", { bg = colorUtils.darken(frappe.green, 0.36, mocha.base) })
      vim.api.nvim_set_hl(0, "OctoReviewDiffDeleteText", { bg = colorUtils.darken(frappe.red, 0.36, mocha.base) })

      return {
        picker = "telescope",
        enable_builtin = true,
        default_merge_method = "squash",
        users = "assignable",
        notifications = {
          current_repo_only = true,
        },
        reviews = {
          auto_show_threads = false,
        },
        colors = {
          white = latte.crust,
          grey = mocha.surface0,
          black = mocha.crust,
          red = frappe.maroon,
          dark_red = frappe.red,
          green = frappe.teal,
          dark_green = frappe.green,
          yellow = frappe.yellow,
          dark_yellow = mocha.yellow,
          blue = frappe.sapphire,
          dark_blue = frappe.blue,
          purple = frappe.mauve,
        },
      }
    end,
    keys = {
      { "<leader>oi", "<CMD>Octo issue list<CR>",
        desc = "List GitHub Issues",
        silent = true,
      },
      { "<leader>op", "<CMD>Octo pr list<CR>",
        desc = "List GitHub PullRequests",
        silent = true,
      },
      { "<leader>od", "<CMD>Octo discussion list<CR>",
        desc = "List GitHub Discussions",
        silent = true,
      },
      { "<leader>on", "<CMD>Octo notification list<CR>",
        desc = "List GitHub Notifications",
        silent = true,
      },
      { "<leader>os",
        function()
          require("octo.utils").create_base_search_command { include_current_repo = true }
        end,
        desc = "Search GitHub",
        silent = true,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-mini/mini.icons",
    },
  },
}
