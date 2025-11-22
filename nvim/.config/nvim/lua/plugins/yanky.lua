return {
  {
    "gbprod/yanky.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      system_clipboard = {
        sync_with_ring = false,
      },
      highlight = {
        timer = 250,
      },
    },
    config = function(_, opts)
      require("yanky").setup(opts)
      require("telescope").load_extension "yank_history"
      vim.keymap.set("n", "<leader>p", "<CMD>Telescope yank_history<CR>", {
        desc = "Open yank history.",
        silent = true,
      })
    end,
  },
}
