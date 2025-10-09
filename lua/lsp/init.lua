-- LSPの起動状態を確認する
vim.api.nvim_create_user_command(
  'LspHealth',
  'checkhealth vim.lsp',
  { desc = 'LSP health check' })

-- 診断結果を画面上に表示する
vim.diagnostic.config({
  virtual_text = true
})

local augroup = vim.api.nvim_create_augroup('muramasa64/lsp/lua', {})

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/definition') then
      -- grd で関数定義の部分にジャンプする
      vim.keymap.set('n', 'grd', function()
        vim.lsp.buf.definition()
      end, { buffer = args.buf, desc = 'vim.lsp.buf.definition()' })
    end

    if client:supports_method('textDocument/formatting') then
      -- <space>i で、バッファーをフォーマットする
      vim.keymap.set('n', '<space>i', function()
        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
      end, { buffer = args.buf, desc = 'format buffer' })
    end
  end,
})

-- 動作するルートディレクトリを設定する
vim.lsp.config('*', {
  root_markers = { '.git' },
  capabilities = require('mini.completion').get_lsp_capabilities(),
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "single"
  }
)

-- lua_lsが使うコマンドと、対象となるファイルタイプを設定する
-- local lua_ls_opts = require('muramasa64.lsp.lua_ls')
-- vim.lsp.config('lua_ls', lua_ls_opts)
--
-- -- lspを有効化する
-- vim.lsp.enable('lua_ls')

-- lspディレクトリ以下のファイルをまとめて読み込む
-- このファイルの存在するディレクトリ
local dirname = vim.fn.stdpath('config') .. '/lua/lsp'

-- 設定したlspを保存する配列
local lsp_names = {}

-- 同一ディレクトリのファイルをループ
for file, ftype in vim.fs.dir(dirname) do
  -- `.lua`で終わるファイルを処理（init.luaは除く）
  if ftype == 'file' and vim.endswith(file, '.lua') and file ~= 'init.lua' then
    -- 拡張子を除いてlsp名を作る
    local lsp_name = file:sub(1, -5) -- fname without '.lua'
    -- 読み込む
    local ok, result = pcall(require, 'lsp.' .. lsp_name)
    if ok then
      -- 読み込めた場合はlspを設定
      vim.lsp.config(lsp_name, result)
      table.insert(lsp_names, lsp_name)
    else
      -- 読み込めなかった場合はエラーを表示
      vim.notify('Error loading LSP: ' .. lsp_name .. '\n' .. result, vim.log.levels.WARN)
    end
  end
end

-- 読み込めたlspを有効化
vim.lsp.enable(lsp_names)

