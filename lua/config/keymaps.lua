-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Jump between GitHub-issue / markdown checkboxes ([ ], [x], [X]) — lands on the box.
-- Uses vim.fn.search so it doesn't clobber the last-search register or hlsearch.
vim.keymap.set("n", "<C-j>", function() vim.fn.search("\\[[ xX]\\]", "W") end, { desc = "Next checkbox" })
vim.keymap.set("n", "<C-k>", function() vim.fn.search("\\[[ xX]\\]", "bW") end, { desc = "Previous checkbox" })

-- Toggle a [ ]/[x] checkbox on the current line, in ANY buffer (markdown
-- reports, notes, ...). Octo buffers shadow this with a buffer-local map
-- that also writes, so octo's toggle-and-push behavior is unchanged.
vim.keymap.set("n", "<leader>X", function()
  local line = vim.api.nvim_get_current_line()
  local toggled
  if line:find("%[ %]") then
    toggled = line:gsub("%[ %]", "[x]", 1)
  elseif line:find("%[[xX]%]") then
    toggled = line:gsub("%[[xX]%]", "[ ]", 1)
  else
    vim.notify("no checkbox on this line", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_set_current_line(toggled)
end, { desc = "Toggle checkbox" })
