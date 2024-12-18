return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    "zbirenbaum/copilot-cmp"
  },
  config = function()
    require("copilot").setup({
      -- Suggestions settings
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-Right>",
          accept_line = "<M-C-Right>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      -- Panel settings (for showing multiple suggestions)
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "<M-[>",
          jump_next = "<M-]>",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
      },
      -- File type specific settings
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      -- Copilot CMP source configuration
      copilot_node_command = 'node', -- Node.js version 18 or higher
      server_opts_overrides = {},
    })

    -- Set up Copilot CMP source
    require("copilot_cmp").setup()
  end
}