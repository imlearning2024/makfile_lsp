# makefile_ls.nvim

🔧 Minimal Makefile support for Neovim using `nvim-cmp` and `none-ls.nvim`.

- 🧠 Target suggestions from Makefiles
- 🛠️ Tab-fixes for formatting (converts spaces to real tabs)

## Installation

Lazy.nvim:

```lua
{
  url = "https://github.com/imlearning2024/makfile_lsp.git",
  ft = { "make" },
  config = function()
    require("makefile_ls").setup()
  end,
}
```

## Dependencies

- `hrsh7th/nvim-cmp`
- `nvimtools/none-ls.nvim`

## Author

Built with 💻 by [@imlearning2024](https://github.com/imlearning2024)
Built with 💻 by [@Vatsalj17](https://github.com/Vatsalj17)
