return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    cmd = {
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        'cssls',
        'eslint',
        'gopls',
        'html',
        'jsonls',
        'rust_analyzer',
        'stylelint_lsp',
        'ts_ls',
      },
    },
  },
}
