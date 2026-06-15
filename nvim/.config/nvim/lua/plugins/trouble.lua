return {
  {
    "folke/trouble.nvim",
    lazy = true,
    cmd = "Trouble",
    opts = {
      auto_preview = false,
      auto_refresh = false,
      focus = true,
      modes = {
        symbols = {
          desc = "document symbols",
          mode = "lsp_document_symbols",
          auto_refresh = true,
          multiline = false,
          focus = true,
          win = { position = "right" },
          filter = {
            -- remove Package since luals uses it for control flow structures
            ["not"] = { ft = "lua", kind = "Package" },
            any = {
              -- all symbol kinds for help / markdown files
              ft = { "help", "markdown" },
              -- default set of symbol kinds
              kind = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Package",
                "Property",
                "Struct",
                "Trait",
              },
            },
          },
        },
        buffer_diagnostics = {
          mode = "diagnostics",
          auto_refresh = true,
          groups = { "severity", "filename" },
          filter = { buf = 0 },
          sort = { "pos" },
        },
      },
    },
    keys = {
      { "<leader>gD", "<CMD>Trouble lsp_declarations<CR>",
        desc = "Goto declaration or shop options.",
        silent = true,
      },
      { "<leader>d", "<CMD>Trouble buffer_diagnostics<CR>",
        desc = "Show diagnostics for current buffer.",
        silent = true,
      },
      { "gs", "<CMD>Trouble lsp_document_symbols<CR>",
        desc = "Show document symbols.",
        silent = true,
      },
      { "gO", "<CMD>Trouble lsp_document_symbols<CR>",
        desc = "Show document symbols.",
        silent = true,
      },
    },
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end
    },
  },
}
