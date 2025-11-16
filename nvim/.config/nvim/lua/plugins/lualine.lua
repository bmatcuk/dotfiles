return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
          refresh_time = 16, -- ~60fps
          events = {
            "WinEnter",
            "BufEnter",
            "BufWritePost",
            "SessionLoadPost",
            "FileChangedShellPost",
            "VimResized",
            "Filetype",
            "CursorMoved",
            "CursorMovedI",
            "ModeChanged",
          },
        }
      },
      sections = {
        lualine_a = {"mode"},
        lualine_b = {"branch", "diff"},
        lualine_c = {"filename"},
        lualine_x = {"encoding", "fileformat"},
        lualine_y = {"progress", "location"},
        lualine_z = {
          -- "lsp_status",
          {
            "diagnostics",
            sources = { "nvim_lsp", "nvim_diagnostic" },
            sections = { "warn", "error" },
            symbols = {
              error = '✗',
              warn = '◆',
            },
          },
        }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
        lualine_x = {"encoding", "fileformat"},
        lualine_y = {"progress", "location"},
        lualine_z = {
          -- "lsp_status",
          {
            "diagnostics",
            sources = { "nvim_lsp", "nvim_diagnostic" },
            sections = { "warn", "error" },
            symbols = {
              error = '✗',
              warn = '◆',
            },
          },
        }
      },
      tabline = {
        lualine_a = {
          {
            "buffers",
            show_filename_only = false,
            icons_enabled = false,
            buffers_color = {
              active = 'lualine_a_normal',
              inactive = 'lualine_c_inactive',
            },
          },
        },
      },
      winbar = {},
      inactive_winbar = {},
      extensions = {"fzf", "lazy", "mason", "quickfix", "trouble"}
    },
  },
}
