-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Jump between GitHub-issue / markdown checkboxes ([ ], [x], [X]) — lands on the box.
-- Uses vim.fn.search so it doesn't clobber the last-search register or hlsearch.
vim.keymap.set("n", "<C-j>", function() vim.fn.search("\\[[ xX]\\]", "W") end, { desc = "Next checkbox" })
vim.keymap.set("n", "<C-k>", function() vim.fn.search("\\[[ xX]\\]", "bW") end, { desc = "Previous checkbox" })

-- Toggle [ ]/[x] checkboxes in ANY buffer (markdown reports, notes, ...).
-- Normal mode: current line. Visual mode: every selected line that has a
-- box (lines without one are skipped silently). Octo buffers shadow the
-- normal-mode map with a buffer-local version that also writes/pushes.
local function toggle_checkbox_line(lnum)
  local line = vim.fn.getline(lnum)
  local toggled
  if line:find("%[ %]") then
    toggled = line:gsub("%[ %]", "[x]", 1)
  elseif line:find("%[[xX]%]") then
    toggled = line:gsub("%[[xX]%]", "[ ]", 1)
  end
  if toggled then
    vim.fn.setline(lnum, toggled)
    return true
  end
  return false
end

vim.keymap.set("n", "<leader>X", function()
  if not toggle_checkbox_line(vim.fn.line(".")) then
    vim.notify("no checkbox on this line", vim.log.levels.WARN)
  end
end, { desc = "Toggle checkbox" })

vim.keymap.set("x", "<leader>X", function()
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then s, e = e, s end
  local n = 0
  for lnum = s, e do
    if toggle_checkbox_line(lnum) then n = n + 1 end
  end
  vim.notify(("toggled %d checkbox%s"):format(n, n == 1 and "" or "es"))
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Toggle checkboxes in selection" })
