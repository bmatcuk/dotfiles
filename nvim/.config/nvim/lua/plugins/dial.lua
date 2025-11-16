return {
  {
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.semver.alias.semver,
          augend.constant.new {
            elements = { "true", "false" },
            word = true,
            cyclic = true,
            preserve_case = true,
          },
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%H:%M"],
          augend.constant.new {
            elements = { "Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun" },
            word = true,
            cyclic = true,
          },
          augend.constant.alias.en_weekday_full,
          augend.constant.new {
            elements = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" },
            word = true,
            cyclic = true,
          },
        },
      }
    end,
    keys = {
      { "<C-A>", "<Plug>(dial-increment)",
        desc = "Increment.",
        mode = {"n", "x"},
        silent = true,
      },
      { "g<C-A>", "<Plug>(dial-g-increment)",
        desc = "Increment.",
        mode = {"n", "x"},
        silent = true,
      },
      { "<C-x>", "<Plug>(dial-decrement)",
        desc = "Decrement.",
        mode = {"n", "x"},
        silent = true,
      },
      { "g<C-x>", "<Plug>(dial-g-decrement)",
        desc = "Decrement.",
        mode = {"n", "x"},
        silent = true,
      },
    },
  },
}
