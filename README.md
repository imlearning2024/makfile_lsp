# makefile_ls.nvim

🔧 Minimal Makefile support for Neovim using `nvim-cmp` and `none-ls.nvim`.

- 🧠 Target suggestions from Makefiles
- 🛠️ Tab-fixes for formatting (converts spaces to real tabs)

## Installation

Lazy.nvim:

```lua
{
  url = "https://github.com/<your-username>/makefile_ls.nvim",
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

Built with 💻 by [@<your-username>](https://github.com/<your-username>)
