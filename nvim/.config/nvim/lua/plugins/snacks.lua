return {
  {
    "folke/snacks.nvim",
    priority = 998,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File",
              action = function()
                vim.fn.system("git rev-parse --is-inside-work-tree")
                local inside_work_tree = vim.v.shell_error == 0

                if inside_work_tree then
                  Snacks.picker.git_files({
                    cwd = vim.fn.getcwd(),
                    untracked = true,
                    submodules = true,
                  })
                else
                  Snacks.picker.files()
                end
              end,
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          {
            section = "terminal",
            cmd = "fortune -s computers linuxcookie softwareengineering | cowsay -f kitten",
            hl = "header",
            height = 20,
            padding = 2,
            indent = 8,
          },
          { section = "startup" },
          {
            pane = 2,
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 2,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local sections = {
              {
                icon = " ",
                title = "PRs Awaiting My Review",
                cmd = "env -u PAGER GH_FORCE_TTY=t gh pr list -L3 --search 'user-review-requested:@me' | tail -n+4",
                key = "P",
                action = function()
                  Snacks.picker.gh_pr({ search = "user-review-requested:@me" })
                end,
                height = 7,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(section)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 2,
                ttl = 5 * 60,
                indent = 2,
              }, section)
            end, sections)
          end,
        },
      },
      explorer = { enabled = true },
      gh = { enabled = true },
      indent = {
        indent = {
          only_scope = true,
          only_current = true,
        },
        animate = { enabled = false },
      },
      picker = {
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["<c-u>"] = "list_scroll_up",
                  ["<c-d>"] = "list_scroll_down",
                },
              },
            },
          },
          gh_issue = {},
          gh_pr = {},
        },
        win = {
          input = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-u>"] = "preview_scroll_up",
              ["<c-d>"] = "preview_scroll_down",
            },
          },
        },
      },
      scratch = { enabled = true },
    },
    keys = {
      -- gh
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      -- explorer
      { "<leader>e",
        function()
          -- Some ideas stolen from:
          -- https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-16142359
          Snacks.explorer.open({
            layout = { preset = "default", preview = true },
            tree = false,
            auto_close = true,
            jump = { close = true },
            icons = {
              tree = { last = "", middle = "", vertical = "" },
            },
            on_show = function(picker)
              picker.cwd_jumplist = {}
            end,
            transform = function(item, ctx)
              local no_tree = ctx.picker.opts.tree == false
              if no_tree and ctx.filter.meta.searching ~= true then
                -- Hide nested
                item.open = item.file == ctx:cwd()
                return vim.tbl_get(item, "parent", "parent") == nil
              end
            end,
            format = function(item, picker)
              local fmt = Snacks.picker.format.file(item, picker)
              local cwd = picker:cwd()
              if item.file == cwd then
                fmt[2] = { "𖣂 " .. vim.fs.basename(cwd), "SnacksPickerDirectory" }
              end
              return fmt
            end,
            config = function(opts)
              opts = require("snacks.picker.source.explorer").setup(opts)
              opts.actions.confirm = function(picker, item, action)
                local Actions = require("snacks.explorer.actions")
                if picker.input.filter.meta.searching then
                  picker:set_cwd(vim.fs.dirname(item.file))
                  Actions.update(picker, { refresh = true, target = item.file })
                elseif item.file == picker:cwd() then
                  picker:action("explorer_up")
                elseif item.dir then
                  picker:set_cwd(item.file)
                  local target = picker.cwd_jumplist[item.file]
                  Actions.update(picker, { refresh = true, target = target })
                else
                  Actions.actions.confirm(picker, item, action)
                end
              end
              return opts
            end,
            actions = {
              explorer_up = function(picker, item)
                local Actions = require("snacks.explorer.actions")
                local cwd = picker:cwd()
                picker.cwd_jumplist[cwd] = item.file
                picker:set_cwd(vim.fs.dirname(cwd))
                Actions.update(picker, { refresh = true, target = cwd })
              end,
              go_left = function(picker)
                picker:action("explorer_up")
              end,
              go_right = function(picker, item)
                if item.file ~= picker:cwd() then
                  picker:action("confirm")
                end
              end,
            },
            win = {
              list = {
                keys = {
                  ["h"] = "go_left",
                  ["l"] = "go_right",
                },
              },
            },
          })
        end,
        desc = "Open file browser.",
      },
      -- lazygit
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Open lazygit." },
      { "<leader>gh", function() Snacks.lazygit.log_file() end, desc = "Open gitlog for this file." },
      -- picker
      { "<C-p>",
        function()
          vim.fn.system("git rev-parse --is-inside-work-tree")
          local inside_work_tree = vim.v.shell_error == 0

          if inside_work_tree then
            Snacks.picker.git_files({
              cwd = vim.fn.getcwd(),
              untracked = true,
              submodules = true,
            })
          else
            Snacks.picker.files()
          end
        end,
        desc = "Find files.",
      },
      { "<leader>be", function() Snacks.picker.buffers() end, desc = "Switch buffer." },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history." },
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto definition or show options." },
      { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto implementation or show options." },
      { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto implementation or show options." },
      { "gr", function() Snacks.picker.lsp_references() end, desc = "Goto reference or show options." },
      { "grr", function() Snacks.picker.lsp_references() end, desc = "Goto reference or show options." },
      { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto type definition or show options." },
      { "gs", function() Snacks.picker.lsp_symbols() end, desc = "Symbols in the current document." },
      { "gO", function() Snacks.picker.lsp_symbols() end, desc = "Symbols in the current document." },
      { "\\", function() Snacks.picker.grep() end, desc = "Grep." },
      { "<leader>\\", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor." },
      { "<space>u", function() Snacks.picker.undo() end, desc = "Open undo history." },
      -- scratch
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    },
  },
}
