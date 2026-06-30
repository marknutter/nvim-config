-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable swapfiles for octo.nvim buffers. octo opens each issue/PR in a buffer
-- named octo://<repo>/issue/<n>; when nvim exits uncleanly it leaves a .swp
-- behind, and reopening the same issue then throws E325 (ATTENTION) when octo
-- writes to the buffer. These buffers are just views of GitHub data — there's
-- nothing to recover from a swap — so turning swapfiles off kills the error.
vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("octo_no_swapfile", { clear = true }),
  pattern = "octo://*",
  callback = function()
    vim.opt_local.swapfile = false
  end,
})

-- nvim-autosync round-trip test marker
