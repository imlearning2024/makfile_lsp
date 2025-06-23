local M = {}

-- === Target Extraction ===
local function extract_targets(bufnr)
  local targets = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    local target = line:match("^(%S+):")
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
  local builtins = { "$(CC)", "$(CFLAGS)", "$(MAKE)", "$(RM)", "$(OBJ)", "@echo", "@rm -f" }
  local all = vim.tbl_extend("force", targets, builtins)

  local items = vim.tbl_map(function(word)
    return { label = word, kind = 14 }
  end, all)

  callback({ items = items, isIncomplete = false })
end

-- === Setup Function ===
function M.setup()
  -- Register CMP source
  require("cmp").register_source("makefile_ls", cmp_source.new())

  -- Register with none-ls
  local null_ls = require("null-ls")
  null_ls.register({
    name = "makefile_formatter",
    filetypes = { "make" },
    method = null_ls.methods.FORMATTING,
    generator = {
      fn = function(params)
        local new_lines = {}
        for _, line in ipairs(params.content) do
          if line:match("^%s") and not line:match("^\t") then
            table.insert(new_lines, line:gsub("^%s+", "\t"))
          else
            table.insert(new_lines, line)
          end
        end
        return { { text = table.concat(new_lines, "\n") } }
      end,
    },
  })
end

return M
