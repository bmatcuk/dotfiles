return {
  {
    "gbprod/yanky.nvim",
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
    init = function(_, opts)
      require("telescope").load_extension "yank_history"
      vim.keymap.set("n", "<leader>p", "<CMD>Telescope yank_history<CR>", {
        desc = "Open yank history.",
        silent = true,
      })
    end,
  },
}
