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
    local target = line:match("^(%S+):")
    if target and not vim.tbl_contains(targets, target) then
      table.insert(targets, target)
    end
  end

  local builtins = { "$(CC)", "$(CFLAGS)", "$(MAKE)", "$(RM)", "$(OBJ)", "@echo", "@rm -f" }
  local all = vim.tbl_extend("force", targets, builtins)

  local items = vim.tbl_map(function(word)
    return { label = word, kind = 14 }
  end, all)

  callback({ items = items, isIncomplete = false })
end

return cmp_source



