-- aerial.nvim
-- 開いているファイルの構造からミニマップを表示する
MiniDeps.later(function()
  MiniDeps.add({ source = 'https://github.com/stevearc/aerial.nvim' })
  require('aerial').setup({
    on_attach = function(bufnr)
      vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr })
    end,
  })
end)
vim.keymap.set("n", "<space>a", "<cmd>AerialToggle!<cr>")
