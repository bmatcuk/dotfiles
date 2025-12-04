return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    lazy = false,
    opts = {
      ensure_installed = {
        "cssls", -- "css-lsp",
        "eslint", --"eslint-lsp",
        "gopls",
        "html", -- "html-lsp",
        "jsonls", -- "json-lsp",
        "rust_analyzer", -- "rust-analyzer",
        "stylelint_lsp", -- "stylelint",
        "tsgo",
      },
    },
    init = function()
      vim.lsp.config("*", {
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
      })

      vim.lsp.config("cssls", {
        settings = {
          css = { validate = false },
          less = { validate = false },
          scss = { validate = false },
        },
      })

      vim.lsp.config("stylelint_lsp", {
        settings = {
          stylelintplus = {
            autoFixOnFormat = true
          }
        }
      })
    end,
  },
}
