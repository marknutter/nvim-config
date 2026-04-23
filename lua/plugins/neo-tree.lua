return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = { enabled = true },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
    keys = {
      {
        "<leader>fd",
        function()
          vim.ui.input({
            prompt = "Directory: ",
            default = "~/",
            completion = "dir",
          }, function(input)
            if input and input ~= "" then
              local path = vim.fn.expand(input)
              require("neo-tree.command").execute({ action = "close" })
              vim.cmd("cd " .. path)
              require("neo-tree.command").execute({
                source = "filesystem",
                position = "left",
                dir = path,
                reveal = true,
              })
            end
          end)
        end,
        desc = "Neotree: jump to directory",
      },
    },
  },
}
