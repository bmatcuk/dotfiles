return {
  {
    "ravitemer/mcphub.nvim",
    build = "bundled_build.lua",
    opts = {
      use_bundled_binary = true,
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
