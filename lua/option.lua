-- 表示に関する設定
vim.opt.number = true     -- 行番号を表示する
vim.opt.cursorline = true -- カーソル行をハイライトする
vim.opt.scrolloff = 3     -- カーソルの上または下に、最低限表示される行数
vim.opt.wrap = true -- 長い行を折り返す
vim.opt.linebreak = false -- そのまま折り返す

-- インデントの設定
vim.opt.expandtab = true  -- タブを\tではなくスペースで表す
vim.opt.shiftround = true -- インデントを shiftwidth の倍数に丸める
vim.opt.shiftwidth = 2    -- インデント実行時の幅
vim.opt.softtabstop = 2   -- インサートモードでTabキーまたはBackspaceキーを押すとカーソルが移動する位置
vim.opt.tabstop = 4       -- 水平タブ文字（Ascii code 9）を使う時に表示する幅

-- カーソルの動きに関する設定
vim.opt.whichwrap = 'b,s,h,l,<,>,[,],~' -- 行頭または行末で、次のキーを使った時に、カーソルが次の行に移動させる

-- クリップボードの設定
-- vim.opt.clipboard:append('unnamedplus,unnamed') -- クリップボードをOSと共有する

-- shell
vim.opt.shell = 'fish'
