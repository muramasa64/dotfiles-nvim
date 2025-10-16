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

MiniDeps.now(function()
  vim.cmd.colorscheme('tokyonight')
end)

