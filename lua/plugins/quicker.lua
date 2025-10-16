-- quicker.nvim
-- 検索して出てきたquickfixを直接編集することができる
-- '>' で、直前と直後の列を展開する
-- '<' で、展開したのを戻す
-- 'mq' で、quickfixを開いたり閉じたりする（トグル）
MiniDeps.later(function()
  MiniDeps.add({ source = 'https://github.com/stevearc/quicker.nvim' })
  local quicker = require('quicker')
  vim.keymap.set('n', 'mq', function ()
    quicker.toggle()
    quicker.refresh()
  end, { desc = 'Toggle quickfix' })
  quicker.setup({
    keys = {
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
  })
end)

