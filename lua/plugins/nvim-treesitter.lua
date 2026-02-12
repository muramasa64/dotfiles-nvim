MiniDeps.later(function()
  MiniDeps.add({
    source = 'https://github.com/nvim-treesitter/nvim-treesitter',
    branch = 'main',
  })
  require('nvim-treesitter').setup({})
end)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
  callback = function(ctx)
    pcall(vim.treesitter.start)
  end,
})
