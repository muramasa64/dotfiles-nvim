-- この設定のベースは、Neovimを始めよう feat. mini.nvim（https://zenn.dev/kawarimidoll/books/6064bf6f193b51）

-- init.luaをキャッシュする
vim.loader.enable()

require('option')
require('user_command')
require('bool_fn')
require('keymap')

-- augroup for this config file
local augroup = vim.api.nvim_create_augroup('init.lua', {})

-- wrapper function to use internal augroup
-- init.lua という augroup でnvim_create_autocmdを実行する
local function create_autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend('force', {
    group = augroup,
  }, opts))
end

-- ファイルを保存する際にディレクトリが存在しなかった場合に自動的に作成する
-- https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(event)
    local dir = vim.fs.dirname(event.file)
    local force = vim.v.cmdbang == 1
    if vim.fn.isdirectory(dir) == 0
        and (force or vim.fn.confirm('"' .. dir .. '" does not exist. Create?', "&Yes\n&No") == 1) then
      vim.fn.mkdir(vim.fn.iconv(dir, vim.opt.encoding:get(), vim.opt.termencoding:get()), 'p')
    end
  end,
  desc = 'Auto mkdir to save file'
})

-- 短縮入力モードをExコマンドのみにする（検索中は対象外とする）
local function abbrev_excmd(lhs, rhs, opts)
  vim.keymap.set('ca', lhs, function()
    return vim.fn.getcmdtype() == ':' and rhs or lhs
  end, vim.tbl_extend('force', { expr = true }, opts))
end

-- qw を wq にする
abbrev_excmd('qw', 'wq', { desc = 'fix typo' })

-- 内部grepを使って検索した結果の一覧をquickfixに表示する
-- / で検索し、?を入力するとquickfixが展開する
vim.keymap.set('n', '?', '<cmd>silent vimgrep//gj%|copen<cr>', { desc = 'Populate latest search result to quickfix list' })

-- rg (ripgrep)を使う
vim.opt.grepprg = table.concat({
  'rg',
  '--vimgrep', -- 行と列を含めて結果を出力する
  '--trim',    -- インデントを、検索結果から削除する
  '--hidden',  -- ドットで始まるファイルを検索対象に含める
  [[--glob='!.git']],  -- 特定のファイルを検索結果から除く
  [[--glob='!*.lock']],
  [[--glob='!*.lock.json']],
}, ' ')
vim.opt.grepformat = '%f:%l:%c:%m'

-- :Grep で、rgを使ってファイルを検索する
-- :Grep! とすると、正規表現を使わない
-- ref: `:NewGrep` in `:help grep`
vim.api.nvim_create_user_command('Grep', function(arg)
  local grep_cmd = 'silent grep! '
    .. (arg.bang and '--fixed-strings -- ' or '')
    .. vim.fn.shellescape(arg.args, true)
  vim.cmd(grep_cmd)
  if vim.fn.getqflist({ size = true }).size > 0 then
    vim.cmd.copen()
  else
    -- 検索がヒットしなかった場合はquickfixを開かない
    vim.notify('no matches found', vim.log.levels.WARN)
    vim.cmd.cclose()
  end
end, { nargs = '+', bang = true, desc = 'Enhounced grep' })

vim.keymap.set('n', '<space>/', ':Grep ', { desc = 'Grep' })  -- <space>/ で検索キーワードの入力待ちになる
vim.keymap.set('n', '<space>?', ':Grep <c-r><c-w>', { desc = 'Grep current word' }) -- <space>? で、カーソルの下のファイルを検索対象とする

-- 'mini.nvim'をcloneして、'mini.deps'で管理されるようにする
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- プラグインマネージャー 'mini.deps'をセットアップ
require('mini.deps').setup({ path = { package = path_package } })

-- add: mini.nvim以外のプラグインの読み込み
-- now: 渡されたコールバック関数をすぐに実行する
-- later: 渡されたコールバック関数を遅延実行する
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- add('neovim/nvim-lspconfig')
require('lsp')

require('plugins.colorscheme')
require('plugins.vimdoc-ja')
require('plugins.mini')
-- require('plugins.treesitter')
require('plugins.toggleterm')
require('plugins.aerial')
require('plugins.nvim-surround')
require('plugins.vim-ambiwidth')
require('plugins.obsidian')
require('plugins.nvim-ghost')
-- require('plugins.rainbow_csv')
require('plugins.render-markdown')
require('plugins.nvim-treesitter-textobjects')

-- vim.lsp.config.treesitter_ls = {
--   cmd = { "/Volumes/repos/repos/treesitter-ls/target/release/treesitter-ls" },
-- }
-- vim.lsp.enable("treesitter_ls")

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.treesitter.stop()
  end,
})

-- Vim内蔵のプラグインの読み読みを無効化するハック
-- この部分は、常にinit.luaの最後にある必要がある
-- now(function()
--   local default_rtp = vim.opt.runtimepath:get()
--   vim.opt.runtimepath:remove(vim.env.VIMRUNTIME)
--   create_autocmd("SourcePre", {
--     pattern = "*/plugin/*",
--     once = true,
--     callback = function()
--       vim.opt.runtimepath = default_rtp
--     end
--   })
-- end)
--
