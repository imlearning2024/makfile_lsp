-- This file is optional since the CMP source is now integrated into init.lua
-- Keep it if you want to maintain separation of concerns

local cmp_source = {}

cmp_source.new = function()
  return setmetatable({}, { __index = cmp_source })
end

function cmp_source:is_available()
  return vim.bo.filetype == "make"
end

function cmp_source:complete(_, callback)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local targets = {}

  for _, line in ipairs(lines) do
    local target = line:match("^([^%s:]+):")
    if target and not vim.tbl_contains(targets, target) then
      table.insert(targets, target)
    end
  end

  local builtins = {
    "$(CC)", "$(CFLAGS)", "$(LDFLAGS)", "$(MAKE)", "$(RM)", "$(OBJ)",
    "$(OBJDIR)", "$(SRCDIR)", "$(INCDIR)", "$(BINDIR)",
    "@echo", "@rm", "@mkdir", "@cp", "@mv"
  }

  local items = {}

  -- Add targets
  for _, target in ipairs(targets) do
    table.insert(items, {
      label = target,
      kind = 5, -- Function kind
      detail = "Makefile target",
    })
  end

  -- Add builtins
  for _, builtin in ipairs(builtins) do
    table.insert(items, {
      label = builtin,
      kind = 6, -- Variable kind
      detail = "Makefile builtin",
    })
  end

  callback({ items = items, isIncomplete = false })
end

return cmp_source
