local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitter"
vim.fn.mkdir(parser_install_dir, "p")
vim.opt.runtimepath:append(parser_install_dir)

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'master',
  hooks = {
    post_checkout = function()
      vim.cmd('TSUpdate')
    end
  },
})

require('nvim-treesitter.configs').setup({
  parser_install_dir = parser_install_dir,
  highlight = { enable = true, },
  ensure_installed = {
    'lua',
    'markdown',
    'vim',
    'vimdoc',
  },
})


