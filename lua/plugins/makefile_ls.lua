return {
  dir = vim.fn.stdpath("config") .. "/lua/makefile_ls",
  ft = { "make" },
  dependencies = {
    "hrsh7th/nvim-cmp", -- ensure cmp is available before using
    "nvimtools/none-ls.nvim", -- ensure null-ls (now none-ls) is available
  },
  config = function()
    require("makefile_ls").setup()
  end,
}
