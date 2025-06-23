return {
  name = "makefile_ls",
  dir = vim.fn.stdpath("config") .. "/lua/makefile_ls",
  ft = { "make" },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "nvimtools/none-ls.nvim",
  },
  config = function()
    require("makefile_ls").setup()
  end,
}
