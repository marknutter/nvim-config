-- In-buffer markdown rendering. Styled headings, code-block backgrounds,
-- rendered checkboxes, table borders, etc. Works inside neovim with no
-- external process or browser tab.
--
-- Toggle with `:RenderMarkdown toggle` (also bound to <leader>um below).
-- If you want a browser preview instead, swap this plugin for
-- iamcco/markdown-preview.nvim and use `:MarkdownPreview`.

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
      heading = {
        sign = false,
        position = "inline",
        icons = { "◉ ", "○ ", "✸ ", "✿ ", "▶ ", "▷ " },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },
      pipe_table = {
        preset = "round",
      },
    },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
  },
}
