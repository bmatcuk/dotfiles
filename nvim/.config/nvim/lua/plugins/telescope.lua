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
      "nvim-mini/mini.icons",
    },
    cmd = "Telescope",
    opts = function()
      local actions = require("telescope.actions")
      require("telescope").load_extension("fzf")

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
        pickers = {
          live_grep = {
            mappings = {
              i = {
                ["<c-f>"] = actions.to_fuzzy_refine,
              },
            },
          },
        },
      }
    end,
    keys = {
      { "<C-p>",
        function()
          vim.fn.system("git rev-parse --is-inside-work-tree")
          local inside_work_tree = vim.v.shell_error == 0

          if inside_work_tree then
            require("telescope.builtin").git_files({
              show_untracked = true,
              use_git_root = false,
            })
          else
            require("telescope.builtin").find_files({})
          end
        end,
        desc = "Switch files.",
        silent = true,
      },
      { "<leader>be", "<CMD>Telescope buffers sort_mru=true sort_lastused=true<CR>",
        desc = "Switch buffer.",
        silent = true,
      },
      -- { "\\", "<CMD>Telescope live_grep<CR>",
      --   desc = "Grep.",
      --   silent = true,
      -- },
      {
        "\\",
        function()
          local builtin = require("telescope.builtin")
          builtin.grep_string({
            path_display = { "smart" },
            only_sort_text = true,
            word_match = "-w",
            search = "",
          })
        end,
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
    opts = function()
      local fb_actions = require("telescope._extensions.file_browser.actions")
      return {
        extensions = {
          file_browser = {
            mappings = {
              ["n"] = {
                ["N"] = fb_actions.create,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local TS = require("telescope")
      TS.setup(opts)
      TS.load_extension "file_browser"
    end,
    keys = {
      { "<leader>e", "<CMD>Telescope file_browser path=%:p:h select_buffer=true<CR>",
        desc = "Open file browser.",
        silent = true,
      },
    },
  },

  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    lazy = true,
    opts = function()
      local undo_actions = require("telescope-undo.actions")
      return {
        extensions = {
          undo = {
            mappings = {
              i = {
                ["<CR>"] = undo_actions.restore,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local TS = require("telescope")
      TS.setup(opts)
      TS.load_extension "undo"
    end,
    keys = {
      { "<space>u", "<CMD>Telescope undo<CR>",
        desc = "Open undotree.",
        silent = false,
      },
    },
  },
}
