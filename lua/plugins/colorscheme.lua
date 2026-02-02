-- カラースキームの設定
-- tokyonight
MiniDeps.add({ source = 'folke/tokyonight.nvim' })
require('tokyonight').setup({
  style = "storm",
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
  }
})

-- Catppuccin
MiniDeps.add({ source = 'catppuccin/nvim', name = 'catppuccin' })
require('catppuccin').setup({
  flavor = 'auto',
  background = {
    light = 'latte',
    dark = 'mocha'
  },
  transparent_background = false,
  default_integrations = true,
  integrations = {
    notify = true,
    mini = {
      enable = true
    }
  }
})

-- Edge
MiniDeps.add({ source = 'sainnhe/edge', name = 'edge' })

MiniDeps.now(function()
  -- vim.g.edge_style = 'default'
  -- vim.g.edge_better_performance = 1
  vim.cmd.colorscheme('catppuccin')
end)

