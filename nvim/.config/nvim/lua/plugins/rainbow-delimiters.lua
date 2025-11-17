return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    opts = {
      strategy = {
        [''] = "rainbow-delimiters.strategy.local",
      },
    },
    config = function(_, opts)
      require('rainbow-delimiters.setup').setup(opts)
    end,
  },
}
