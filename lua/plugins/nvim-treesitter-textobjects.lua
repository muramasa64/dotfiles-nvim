MiniDeps.add({
  source = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  checkout = 'main',
})

vim.g.no_plugin_maps = true

-- Or, disable per filetype (add as you like)
-- vim.g.no_python_maps = true
-- vim.g.no_ruby_maps = true
-- vim.g.no_rust_maps = true
-- vim.g.no_go_maps = true

MiniDeps.later(function()
  require('nvim-treesitter-textobjects').setup({
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        -- ['@class.outer'] = '<c-v>', -- blockwise
      },

      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = false,
    },
    move = {
      enable = true,
      set_jumps = true,
    }
  })
end)

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "am", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end, { desc = 'select function outer' })

vim.keymap.set({ "x", "o" }, "im", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end, { desc = 'select function inner' })

vim.keymap.set({ "x", "o" }, "ac", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end, { desc = 'select class outer' })

vim.keymap.set({ "x", "o" }, "ic", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end, { desc = 'select class inner' })

-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end, { desc = 'select local scope' })

vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  require('nvim-treesitter-textobjects.move').goto_next_start("@function.outer", "textobjects")
end, { desc = 'move to next function' })

vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end("@function.outer", "textobjects")
end, { desc = 'move to previous function' })
