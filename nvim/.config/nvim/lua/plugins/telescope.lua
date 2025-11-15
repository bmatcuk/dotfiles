-- some things borrowed from:
-- https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/extras/editor/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        require("telescope.builtin").find_files({ no_ignore = true, default_text = line })
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        require("telescope.builtin").find_files({ hidden = true, default_text = line })
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_with_trouble,
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
    keys = {
      { "<C-p>",
        function()
          local opts = {}

          vim.fn.system("git rev-parse --is-inside-work-tree")
          local inside_work_tree = vim.v.shell_error == 0

          if inside_work_tree then
            require("telescope.builtin").git_files(opts)
          else
            require("telescope.builtin").find_files(opts)
          end
        end,
        desc = "Switch files.",
        silent = true,
      },
      { "<leader>be", "<CMD>Telescope buffers sort_mru=true sort_lastused=true<CR>",
        desc = "Switch buffer.",
        silent = true,
      },
      { "\\", "<CMD>Telescope live_grep<CR>",
        desc = "Grep.",
        silent = true,
      },
      { "<leader>\\", "<CMD>Telescope grep_string<CR>",
        desc = "Grep word under cursor.",
        silent = true,
      },
      { "<leader>:", "<CMD>Telescope command_history<CR>",
        desc = "Command history.",
        silent = true,
      },
      { "<space>D", "<CMD>Telecope lsp_type_definitions<CR>",
        desc = "Goto type definition or show options.",
        silent = true,
      },
      { "gd", "<CMD>Telescope lsp_definitions<CR>",
        desc = "Goto definition or show options.",
        silent = true,
      },
      { "gi", "<CMD>Telescope lsp_implementations<CR>",
        desc = "Goto implementation or show options.",
        silent = true,
      },
      { "gr", "<CMD>Telescope lsp_references<CR>",
        desc = "Goto reference or show options.",
        silent = true,
      },
      { "<leader>d", "<CMD>Telescope buffer_diagnostics bufnr=0<CR>",
        desc = "Diagnostics for current buffer.",
        silent = true,
      },
      { "gs", "<CMD>Telescope lsp_document_symbols<CR>",
        desc = "Symbols in the current document.",
        silent = true,
      },
    },
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    build = "make",
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
    config = function()
      require("telescope").load_extension "file_browser"
    end,
    keys = {
      { "<leader>e", "<CMD>Telescope file_browser path=%:p:h select_buffer=true<CR>",
        desc = "Open file browser.",
        silent = true,
      },
    },
  },
}
