return {
  {
    "neovim/nvim-lspconfig",
    init = function()
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

      vim.keymap.set("n", "K",
        function()
          vim.cmd [[
            if (index(['vim','help'], &filetype) >= 0)
              execute 'h '.expand('<cword>')
            else
              call v:lua.vim.lsp.buf.hover()
            endif
          ]]
        end, {
        desc = "Show documentation.",
        silent = true,
      })
    end,
  },
}
