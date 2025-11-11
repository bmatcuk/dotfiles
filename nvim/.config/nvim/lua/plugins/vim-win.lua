return {
  {
    "dstein64/vim-win",
    lazy = true,
    cmd = "Win",
    keys = {
      { "<leader>w" },
      { "-", ":<C-u>Win 1<CR>",
        desc = "Exit vim-win mode after a single action.",
        silent = true,
      },
    },
  },
}
