-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- ~/.config/nvim/lua/config/options.lua
-- OSC 52 clipboard provider. Routes yanks through the terminal's escape
-- sequence so they land in the LOCAL machine's clipboard, regardless of
-- whether the nvim is running over SSH, inside zellij/tmux, via Apple
-- Screen Sharing, or locally. Ghostty + every modern terminal supports it.
-- Unconditional is safer than gating on SSH_TTY (which mosh, zellij, and
-- screen-share sessions don't always set).
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
vim.opt.clipboard = "unnamedplus"
