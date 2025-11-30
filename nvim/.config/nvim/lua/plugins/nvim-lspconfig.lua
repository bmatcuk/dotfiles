return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 800,
    init = function()
      -- Mason doesn't handle gleam:
      -- https://github.com/mason-org/mason-registry/pull/3872
      vim.lsp.enable('gleam')

      vim.keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, {
        desc = "Display signature help.",
        silent = true,
      })

      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
        desc = "Rename.",
        silent = true,
      })

      vim.keymap.set({ "n", "x" }, "<space>ca", vim.lsp.buf.code_action, {
        desc = "Code action.",
        silent = true,
      })

      vim.keymap.set({ "n", "x" }, "<leader>f", vim.lsp.buf.format, {
        desc = "Format.",
        silent = true,
      })

      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
        desc = "Goto previous diagnostic message.",
        silent = false,
      })

      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
        desc = "Goto next diagnostic message.",
        silent = false,
      })

      vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, {
        desc = "Open diagnostic.",
        silent = true,
      })

      -- highlight symbol under cursor
      local augroup = vim.api.nvim_create_augroup("mylspgroup", { clear = true })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = augroup,
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if client:supports_method('textDocument/documentHighlight') then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              callback = vim.lsp.buf.document_highlight,
              buffer = args.buf,
              group = augroup,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved" }, {
              callback = vim.lsp.buf.clear_references,
              buffer = args.buf,
              group = augroup,
            })
          end
        end,
      })
    end,
  },
}
