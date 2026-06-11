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

          local parsers = require("nvim-treesitter.parsers")
          if not parsers[lang] then
            return
          end

          local installed = vim.treesitter.get_parser(bufnr, lang)
          if not installed then
            if not TS.install({ lang }):wait() then
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

          vim.api.nvim_exec_autocmds("User", {
            pattern = "MyTreesitterReady",
            data = vim.tbl_extend("keep", {}, ev, { lang = lang }),
          })
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    lazy = false,
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- extention to create buffer-local keymaps
        keys = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin
      vim.g.no_plugin_maps = true
    end,
    config = function(_, opts)
      local TSTO = require("nvim-treesitter-textobjects")
      TSTO.setup(opts)

      if not vim.tbl_get(opts, "move", "enable") then
        return
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MyTreesitterReady",
        group = vim.api.nvim_create_augroup("mytextobjectsgroup", { clear = true }),
        callback = function(ev)
          if not vim.treesitter.query.get(ev.data.lang, "textobjects") then
            return
          end

          local moves = vim.tbl_get(opts, "move", "keys") or {}
          for method, keymaps in pairs(moves) do
            for key, query in pairs(keymaps) do
              local queries = type(query) == "table" and query or { query }
              local parts = {}
              for _, q in ipairs(queries) do
                local part = q:gsub("@", ""):gsub("%..*", "")
                part = part:sub(1, 1):upper() .. part:sub(2)
                table.insert(parts, part)
              end
              local desc = table.concat(parts, " or ")
              desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
              desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
              if not (vim.wo.diff and key:find("[cC]")) then
                vim.keymap.set({ "n", "x", "o" }, key, function()
                  require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
                end, {
                  buffer = bufnr,
                  desc = desc,
                  silent = true,
                })
              end
            end
          end
        end,
      })
    end,
  },
}
