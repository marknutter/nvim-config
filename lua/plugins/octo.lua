-- octo.nvim — edit GitHub issues/PRs in real nvim buffers and `:w` to sync.
-- Replaces a read-only issue *picker* (a finder) with an *editor*: open an issue,
-- flip a `- [ ]` task-list checkbox, and push it back to GitHub.
--
-- Requires the `gh` CLI to be authenticated (`gh auth status`). On a machine where
-- gh isn't logged in, octo's commands will error until you `gh auth login`.
return {
  -- LazyVim's snacks-picker spec also claims <leader>gi/gI/gp for its own
  -- read-only gh:// pickers (Snacks.picker.gh_issue / gh_pr). Two plugins on
  -- one key is a first-registrant-wins race in lazy.nvim's key handler, so the
  -- octo bindings below only won the key on some sessions. Setting the key to
  -- `false` removes snacks' claim entirely, making octo the sole, deterministic
  -- owner. <leader>gP is left alone: octo doesn't bind it, so the snacks
  -- "all PRs" picker stays available there.
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gi", false },
      { "<leader>gI", false },
      { "<leader>gp", false },
    },
  },
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
      -- Octo buffers must not use a swap file (E325 ATTENTION on open).
      --
      -- octo builds its buffers with `nvim_create_buf(true, false)` (init.lua:377)
      -- -- listed, NOT scratch -- so 'swapfile' stays on from the global default,
      -- and `configure()` never turns it off. Every issue you open therefore
      -- writes ~/.local/state/nvim/swap/octo:%%owner%repo%issue%N.swp.
      --
      -- That swap is worse than useless here: an octo buffer is a `buftype=acwrite`
      -- view whose contents are re-fetched from the GitHub API on every open, so
      -- there is never anything to recover. But it still collides. Open the same
      -- issue in a second nvim (or leave one behind after an unclean exit) and the
      -- next open finds a swap belonging to another process and raises the E325
      -- "found a swap file" prompt. octo renders inside a vim.schedule callback,
      -- which cannot show an interactive prompt, so the prompt surfaces as
      -- `Vim:E325: ATTENTION` thrown out of nvim_buf_set_lines and the issue
      -- never renders at all.
      --
      -- FileType is the load-bearing hook: octo's configure() runs `setlocal
      -- filetype=octo` before render_issue() writes any lines, and the swap is
      -- only consulted on that first modification -- so this lands in time and the
      -- buffer never touches a swap file. Because it never claims one, a swap held
      -- by another nvim instance is left intact rather than deleted. BufFilePost
      -- covers the `:file octo://...` rename on the picker path and BufAdd covers
      -- `:e octo://...`; both are belt-and-braces ahead of FileType.
      local no_swap_grp = vim.api.nvim_create_augroup("octo_no_swapfile", { clear = true })
      local function disable_swapfile(ev)
        vim.bo[ev.buf].swapfile = false
      end
      vim.api.nvim_create_autocmd({ "BufAdd", "BufFilePost" }, {
        group = no_swap_grp,
        pattern = "octo://*",
        callback = disable_swapfile,
      })
      vim.api.nvim_create_autocmd("FileType", {
        group = no_swap_grp,
        pattern = "octo",
        callback = disable_swapfile,
      })

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
