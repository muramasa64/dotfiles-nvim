MiniDeps.now(function()
  MiniDeps.add({ source = 'https://github.com/epwalsh/obsidian.nvim' })
  -- required
  MiniDeps.add({ source = 'https://github.com/nvim-lua/plenary.nvim' })

  require('obsidian').setup({
    workspaces = {
      {
        name = 'main',
        path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/main',
      }
    },
    ui = {
      enable = false
    },
  })

  vim.keymap.set('n', '<space>oq', '<cmd>ObsidianQuickSwitch<cr>', { desc = 'search Obsidian titles' })
  vim.keymap.set('n', '<space>os', '<cmd>ObsidianSearch<cr>', { desc = 'search obsidian file content' })
  vim.keymap.set('n', '<space>ot', '<cmd>ObsidianTags<cr>', { desc = 'search obsidian tags' })
  vim.keymap.set('n', '<space>on', '<cmd>ObsidianNew<cr>', { desc = 'open new obsidian file' })
  vim.keymap.set('n', '<space>oo', '<cmd>ObsidianOpen<cr>', { desc = 'open obsidian app' })
end)
