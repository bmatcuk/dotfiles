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
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "csv",
        "dart",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "graphql",
        "html",
        "ini",
        "javascript",
        "jq",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "printf",
        "prisma",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "ssh_config",
        "tmux",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
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
