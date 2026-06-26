-- octo.nvim — edit GitHub issues/PRs in real nvim buffers and `:w` to sync.
-- Replaces a read-only issue *picker* (a finder) with an *editor*: open an issue,
-- flip a `- [ ]` task-list checkbox, and push it back to GitHub.
--
-- Requires the `gh` CLI to be authenticated (`gh auth status`). On a machine where
-- gh isn't logged in, octo's commands will error until you `gh auth login`.
return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "Octo: list issues" },
      { "<leader>gI", "<cmd>Octo issue search<cr>", desc = "Octo: search issues" },
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "Octo: list PRs" },
    },
    opts = {
      picker = "snacks", -- use snacks (already installed) as the finder backend
      use_local_fs = false,
      enable_builtin = true,
    },
    config = function(_, opts)
      require("octo").setup(opts)

      -- One-keypress checkbox toggle + push, scoped to octo buffers only.
      -- Flips `- [ ]` <-> `- [x]` on the cursor line, then `:w` (octo syncs the
      -- body to GitHub). This is the single-stroke UX octo lacks out of the box.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "octo",
        callback = function(ev)
          vim.keymap.set("n", "<leader>X", function()
            local line = vim.api.nvim_get_current_line()
            local toggled
            if line:find("%[ %]") then
              toggled = line:gsub("%[ %]", "[x]", 1)
            elseif line:find("%[[xX]%]") then
              toggled = line:gsub("%[[xX]%]", "[ ]", 1)
            else
              vim.notify("octo: no checkbox on this line", vim.log.levels.WARN)
              return
            end
            vim.api.nvim_set_current_line(toggled)
            vim.cmd("write") -- octo pushes the updated body to GitHub
          end, { buffer = ev.buf, desc = "Octo: toggle checkbox + push" })
        end,
      })
    end,
  },
}
