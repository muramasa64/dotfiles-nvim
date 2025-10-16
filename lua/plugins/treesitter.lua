-- treesitter
MiniDeps.now(function()
  MiniDeps.add({
    source = 'https://github.com/nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function()
        vim.cmd.TSUpdate()
      end
    },
  })

  require('nvim-treesitter').setup()

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
    callback = function(ctx)
      pcall(vim.treesitter.start)
    end
  })
end)

