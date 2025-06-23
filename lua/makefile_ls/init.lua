local M = {}

-- === Target Extraction ===
local function extract_targets(bufnr)
  local targets = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    local target = line:match("^([^%s:]+):")
    if target and not vim.tbl_contains(targets, target) then
      table.insert(targets, target)
    end
  end
  return targets
end

-- === CMP Source ===
local cmp_source = {}

cmp_source.new = function()
  return setmetatable({}, { __index = cmp_source })
end

function cmp_source:is_available()
  return vim.bo.filetype == "make"
end

function cmp_source:complete(_, callback)
  local targets = extract_targets(0)
  local builtins = {
    "$(CC)", "$(CFLAGS)", "$(LDFLAGS)", "$(MAKE)", "$(RM)", "$(OBJ)",
    "$(OBJDIR)", "$(SRCDIR)", "$(INCDIR)", "$(BINDIR)",
    "@echo", "@rm", "@mkdir", "@cp", "@mv"
  }

  -- Create completion items for targets
  local items = {}

  for _, target in ipairs(targets) do
    table.insert(items, {
      label = target,
      kind = 5, -- Function kind for targets
      detail = "Makefile target",
      documentation = "Target defined in this Makefile"
    })
  end

  -- Add builtin variables and commands
  for _, builtin in ipairs(builtins) do
    table.insert(items, {
      label = builtin,
      kind = 6, -- Variable kind for builtins
      detail = "Makefile builtin",
      documentation = "Built-in Makefile variable or command"
    })
  end

  callback({ items = items, isIncomplete = false })
end

-- === Formatter ===
local function format_makefile(content)
  local new_lines = {}
  for _, line in ipairs(content) do
    -- Convert leading spaces to tabs for recipe lines
    if line:match("^%s+") and not line:match("^\t") then
      local indent_content = line:match("^%s*(.*)$")
      table.insert(new_lines, "\t" .. indent_content)
    else
      table.insert(new_lines, line)
    end
  end
  return new_lines
end

-- === Setup Function ===
function M.setup(opts)
  opts = opts or {}

  -- Register CMP source
  local cmp_ok, cmp = pcall(require, "cmp")
  if cmp_ok then
    cmp.register_source("makefile_ls", cmp_source.new())
  else
    vim.notify("nvim-cmp not found, skipping CMP source registration", vim.log.levels.WARN)
  end

  -- Register formatter with none-ls
  local null_ls_ok, null_ls = pcall(require, "null-ls")
  if null_ls_ok then
    null_ls.register({
      name = "makefile_formatter",
      filetypes = { "make" },
      method = null_ls.methods.FORMATTING,
      generator = {
        fn = function(params)
          local formatted_lines = format_makefile(params.content)
          return { { text = table.concat(formatted_lines, "\n") } }
        end,
      },
    })
  else
    vim.notify("none-ls not found, skipping formatter registration", vim.log.levels.WARN)
  end

  -- Set up autocmds for makefile-specific features
  vim.api.nvim_create_augroup("MakefileLs", { clear = true })

  -- Auto-completion trigger
  vim.api.nvim_create_autocmd("FileType", {
    group = "MakefileLs",
    pattern = "make",
    callback = function()
      -- Set up buffer-local keymaps or additional features here if needed
      vim.bo.expandtab = false
      vim.bo.tabstop = 4
      vim.bo.shiftwidth = 4
    end,
  })
end

return M
