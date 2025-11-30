-- mostly borrowed from:
-- https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "mason-org/mason-lspconfig.nvim" },
    branch = "main",
    version = false,
    lazy = false,
    priority = 700,
    build = function()
      local mr = require("mason-registry")
      mr.refresh(function()
        local cli = mr.get_package("tree-sitter-cli")
        if not cli:is_installed() then
          cli:install(
            nil,
            function()
              vim.cmd [[:TSUpdate]]
            end
          )
        else
          vim.cmd [[:TSUpdate]]
        end
      end)
    end,
    opts = {},
    config = function(_, opts)
      local TS = require"nvim-treesitter"
      TS.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("mytreesittergroup", { clear = true }),
        callback = function(ev)
          -- ideas from:
          -- https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/treesitter.lua#L103
          -- https://github.com/xaaha/dev-env/blob/0623ecf7d254e94acb8cf232d7dcd84740d72043/nvim/.config/nvim/lua/xaaha/plugins/lsp-nvim-treesitter.lua#L67
          local bufnr = ev.buf
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end

          local installed = pcall(vim.treesitter.get_parser, bufnr, lang)
          if not installed then
            if not TS.install({ lang }) then
              return
            end
          end

          local highlights = vim.treesitter.query.get(lang, "highlights")
          if highlights then
            vim.treesitter.start(bufnr, lang)
          end

          local indents = vim.treesitter.query.get(lang, "indents")
          if indents then
            local current = vim.api.nvim_get_option_value("indentexpr", { scope = "local" })
            if current == "" then
              vim.api.nvim_set_option_value("indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()", { scope = "local" })
            end
          end

          local folds = vim.treesitter.query.get(lang, "folds")
          if folds then
            local method = vim.api.nvim_get_option_value("foldmethod", { scope = "local" })
            local current = vim.api.nvim_get_option_value("foldexpr", { scope = "local" })
            if method ~= "expr" or current == "" then
              vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local" })
              vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { scope = "local" })
            end
          end
        end,
      })
    end,
  },

  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   branch = "main",
  --   version = false,
  --   event = "VeryLazy",
  --   opts = {
  --     move = {
  --       enable = true,
  --       set_jumps = true, -- whether to set jumps in the jumplist
  --       -- LazyVim extention to create buffer-local keymaps
  --       keys = {
  --         goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
  --         goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
  --         goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
  --         goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
  --       },
  --     },
  --   },
  -- },
}
