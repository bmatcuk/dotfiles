return {
  {
    "mbbill/undotree",
    optional = true,
    cmd = {
      "UndotreeShow",
      "UndotreeFocus",
      "UndotreeToggle",
    },
    init = function()
      vim.cmd [[
        let g:undotree_WindowLayout = 2
      ]]
    end,
    keys = {
      { "<space>u", "<CMD>UndotreeShow<CR>:UndotreeFocus<CR>",
        desc = "Open undotree.",
        silent = false,
      },
    },
  },
}
