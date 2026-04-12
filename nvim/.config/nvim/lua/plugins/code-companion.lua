return {
  {
    "olimorris/codecompanion.nvim",
    enabled = function()
      local ok = pcall(require, "local.code-companion")
      return ok
    end,
    opts = function()
      local adapter_setup = require("local.code-companion")
      local adapter = adapter_setup.adapter
      local adapters = {}
      local cli = {}
      if adapter == "claude" then
        local acppath = vim.fn.exepath("claude-agent-acp")
        if string.find(acppath, "/.asdf/", 1, true) then
          -- If claude-agent-acp was installed via a version of node that was,
          -- itself, installed by asdf, `exepath` will always return a value,
          -- but the program may not actually start because it may not be
          -- installed by the specific version of node that is set in this
          -- terminal. So, check if it actually exists.
          vim.fn.system({ "asdf", "which", "claude-agent-acp" })
          if vim.v.shell_error ~= 0 then
            acppath = ""
          end
        end
        if acppath == "" then
          print("Installing claude-agent-acp")
          local out = vim.fn.system({ "npm", "install", "-g", "@agentclientprotocol/claude-agent-acp" })
          if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
              { "Could not install @agentclientprotocol/claude-agent-acp:\n", "ErrorMsg" },
              { out, "WarningMsg" },
              { "\nPress any key..." },
            }, true, {})
          end
        end

        -- install claude code
        -- run `claude setup-token`
        -- create ~/.config/nvim/lua/local/code-companion.lua:
        -- return {
        --   adapter = "claude",
        --   claude_token = "...",
        -- }
        adapter = "claude_code"
        adapters = {
          acp = {
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                env = {
                  CLAUDE_CODE_OAUTH_TOKEN = adapter_setup.claude_token
                },
              })
            end,
          },
        }
        cli = {
          agent = "claude_code",
          agents = {
            claude_code = {
              cmd = "claude",
              args = {},
              description = "Claude Code CLI",
              provider = "terminal",
            },
          },
        }
      elseif adapter == "openrouter" then
        -- create ~/.config/nvim/lua/local/code-companion.lua:
        -- return {
        --   adapter = "openrouter",
        --   openrouter_token = "...",
        -- }
        adapter = "openrouter"
        adapters = {
          http = {
            openrouter = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "https://openrouter.ai/api",
                  api_key = adapter_setup.openrouter_token,
                  chat_url = "/v1/chat/completions",
                },
                schema = {
                  model = {
                    default = "minimax/minimax-m2.7",
                  },
                },
              })
            end,
          },
        }
      end

      return {
        adapters = adapters,
        cli = cli,
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
          },
        },
        interactions = {
          chat = {
            adapter = adapter,
          },
          inline = {
            adapter = adapter,
          },
          cmd = {
            adapter = adapter,
          },
          background = {
            adapter = adapter,
          },
        },
        display = {
          chat = {
            show_settings = true,
          },
        },
        opts = {
          log_level = "TRACE",
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "OXY2DEV/markview.nvim",
      "ravitemer/mcphub.nvim",
    },
  },
}
