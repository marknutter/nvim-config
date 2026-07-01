-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Jump between GitHub-issue / markdown checkboxes ([ ], [x], [X]) — lands on the box.
-- Uses vim.fn.search so it doesn't clobber the last-search register or hlsearch.
vim.keymap.set("n", "<C-j>", function() vim.fn.search("\\[[ xX]\\]", "W") end, { desc = "Next checkbox" })
vim.keymap.set("n", "<C-k>", function() vim.fn.search("\\[[ xX]\\]", "bW") end, { desc = "Previous checkbox" })
