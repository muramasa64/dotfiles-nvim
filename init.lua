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

-- 'mini.icons'
-- Nerd Fontにあるアイコンを使えるようにする
now(function()
  require('mini.icons').setup()
end)

-- 'mini.basics'
-- よく使われるオプションやキーマップをまとめて設定するモジュール
now(function()
  require('mini.basics').setup({
    options = {
      extra_ui = true,
    },
    mappings = {
      option_toggle_prefix = 'm',
    },
  })
end)

-- 日本語のヘルプファイル
later(function()
  add('https://github.com/vim-jp/vimdoc-ja')
  vim.opt.helplang:prepend('ja')
end)

-- mini.statusline
now(function()
  require('mini.statusline').setup()
  vim.opt.laststatus = 3
  vim.opt.cmdheight = 1

  -- 以下の設定は、通常はコマンドラインを0行にして、コマンド入力中や、マクロ記録中はレジスタが見えるように1にする設定
  -- vim.opt.cmdheight = 0
  -- create_autocmd({ 'RecordingEnter', 'CmdlineEnter' }, {
  --   pattern = '*',
  --   callback = function()
  --     vim.opt.cmdheight = 1
  --   end,
  -- })
  --
  -- create_autocmd('RecordingLeave', {
  --   pattern = '*',
  --   callback = function()
  --     vim.opt.cmdheight = 0
  --   end,
  -- })
  --
  -- create_autocmd('CmdlineLeave', {
  --   pattern = '*',
  --   callback = function()
  --     if vim.fn.reg_recording() == '' then
  --       vim.opt.cmdheight = 0
  --     end
  --   end,
  -- })
end)

-- 'mini.misc'
now(function()
  require('mini.misc').setup()

  -- ファイルを開いたときに、以前のカーソル1で開く
  MiniMisc.setup_restore_cursor()

  -- 'Zoom'コマンドで、現在の編集内容以外（ステータスラインなど）を非表示にする（トグル）
  -- mz でも使えるようにしている
  vim.api.nvim_create_user_command('Zoom', function()
    MiniMisc.zoom(0, {})
  end, { desc = 'Zoom current buffer' })
  vim.keymap.set('n', 'mz', '<cmd>Zoom<cr>', { desc = 'Zoom current buffer' })
end)

-- 'mini.notify'
-- 通常はエコー領域に表示されるメッセージをフローティングで出すようにする
now(function()
  require('mini.notify').setup()

  -- ERRORレベルの通知を、10秒間残す
  vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 10000 }
  })

  -- バッファにNotifyの履歴を表示する
  -- 閉じるときは、 bdelete を使うと良い
  vim.api.nvim_create_user_command('NotifyHistory', function()
    MiniNotify.show_history()
  end, { desc = 'Show notify history' })
end)

-- カラースキームの設定
-- tokyonight
add({ source = 'folke/tokyonight.nvim' })
require('tokyonight').setup({
  style = "storm",
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
  }
})
now(function()
  vim.cmd.colorscheme('tokyonight')
end)

-- 'mini.hipaterns'
-- カラーコードや、特定の文字列をハイライトできる
later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = require('mini.extra').gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
      -- Heiglight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- 'mini.cursorword'
-- カーソル位置にある単語に下線を追加する
later(function()
  require('mini.cursorword').setup()
end)

-- 'mini.indentscope'
-- インデントガイドを描画する
later(function()
  require('mini.indentscope').setup()
end)

-- 'mini.trailspace'
-- 行末の空白を表示する
later(function()
  require('mini.trailspace').setup()

  -- :Trimコマンドで、行末の空白をまとめて削除する
  vim.api.nvim_create_user_command(
    'Trim',
    function()
      MiniTrailspace.trim()
      MiniTrailspace.trim_last_lines()
    end,
    { desc = 'Trim trailing space and last blank lines' }
  )
end)

-- 'mini.session'
-- セッション管理
-- :lua MiniSessions.write('session-name') とすると、セッションを保存できる
now(function()
  require('mini.sessions').setup()

  local function is_blank(arg)
    return arg == nil or arg == ''
  end

  local function get_sessions(lead)
    -- ref: https://qiita.com/delphinus/items/2c993527df40c9ebaea7
    return vim
      .iter(vim.fs.dir(MiniSessions.config.directory))
      :map(function(v)
        local name = vim.fn.fnamemodify(v, ':t:r')
        return vim.startswith(name, lead) and name or nil
      end)
      :totable()
  end

  -- SessionWrite で <tab> を実行すると既存のセッションの一覧が表示される
  vim.api.nvim_create_user_command('SessionWrite', function(arg)
    local session_name = is_blank(arg.args) and vim.v.this_session or arg.args
    if is_blank(session_name) then
      vim.notify('No session name specified', vim.log.levels.WARN)
      return
    end
    vim.cmd('%argdelete')
    MiniSessions.write(session_name)
  end, {desc = 'Write session', nargs = '?', complete = get_sessions })

  -- SessionDelete で現在のセッションを削除する
  vim.api.nvim_create_user_command('SessionDelete', function(arg)
    MiniSessions.select('delete', { force = arg.bang })
  end, { desc = 'Delete session', bang = true })

  -- SessionLoadで、Sessionを呼び出す
  vim.api.nvim_create_user_command('SessionLoad', function()
    MiniSessions.select('read', { verbose = true })
  end, { desc = 'Load session'})

  -- SessionEscapeで、現在のSessionから離脱する
  vim.api.nvim_create_user_command('SessionEscape', function()
    vim.v.this_session = ''
  end, { desc = 'Escape session'})

  -- SessionRevealで、現在のセッションを表示する
  vim.api.nvim_create_user_command('SessionReveal', function()
    if is_blank(vim.v.this_session) then
      vim.print('No session')
      return
    end
    vim.print(vim.fn.fnamemodify(vim.v.this_session, ':t:r'))
  end, { desc = 'Reveal session'})
end)

-- 'mini.starter'
-- 起動した際に最近編集したファイルの一覧を出す
now(function()
  require('mini.starter').setup()
end)

-- 'mini.pairs'
-- カッコやクオートがペアで入力される
later(function()
  require('mini.pairs').setup()
end)

-- 'mini.surround'
-- 既存の文字列にカッコを追加したり削除したりできる
later(function()
  require('mini.surround').setup()
end)

-- 'mini.ai', 'mini.extra'
later(function()
  local gen_ai_spec = require('mini.extra').gen_ai_spec
  require('mini.ai').setup({
    custom_textobjects = {
      B = gen_ai_spec.buffer(),
      D = gen_ai_spec.diagnostic(),
      I = gen_ai_spec.indent(),
      L = gen_ai_spec.line(),
      N = gen_ai_spec.number(),
      J = { { '()%d%d%d%d%-%d%d%-%d%d()', '()%d%d%d%d%/%d%d%/%d%d()' } }
    },
  })
end)

now(function()
  local js_like_types = {
    'javascript',
    'javascript.jsx',
    'javascriptreact',
    'typescript',
    'typescript.tsx',
    'typescriptreact'
  }

  create_autocmd('FileType', {
    pattern = js_like_types,
    callback = function()
      -- surround
      vim.b.minisurround_config =
          vim.tbl_deep_extend('force', vim.b.minisurround_config or {}, {
            custom_surroundings = {
              s = {
                input = { '${().-()}' },
                output = { left = '${', right = '}' },
              },
              g = {
                input = { '%f[%w_%.][%w_%.]+%b<>', '^.-<().*()>$' },
                output = function()
                  local generics_name = require('mini.surround').user_input('Generics name')
                  if generics_name == nil then
                    return nil
                  end
                  return { left = generics_name .. '<', right = '>' }
                end,
              },
            },
          })

      -- ai
      vim.b.miniai_config =
          vim.tbl_deep_extend('force', vim.b.miniai_config or {}, {
            custom_textobjects = {
              s = { '${().-()}' },
              g = { '%f[%w_%.][%w_%.]+%b<>', '^.-<().*()>$' },
            },
          })
    end,
    desc = 'Local setting for js-like filetypes'
  })
end)

-- 'mini.cube'
later(function()
  local function mode_nx(keys)
    return { mode = 'n', keys = keys }, { mode = 'x', keys = keys }
  end
  local clue = require('mini.clue')
  clue.setup({
    triggers = {
      -- Leader triggers
      mode_nx('<leader>'),

      -- Built-in completion
      { mode = 'i', keys = '<c-x>' },

      -- `g` key
      mode_nx('g'),

      -- Marks
      mode_nx("'"),
      mode_nx('`'),

      -- Registers
      mode_nx('"'),
      { mode = 'i', keys = '<c-r>' },
      { mode = 'c', keys = '<c-r>' },

      -- Window commands
      { mode = 'n', keys = '<c-w>' },

      -- bracketed commands
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },

      -- `z` key
      mode_nx('z'),

      -- surround
      mode_nx('s'),

      -- text object
      { mode = 'x', keys = 'i' },
      { mode = 'x', keys = 'a' },
      { mode = 'o', keys = 'i' },
      { mode = 'o', keys = 'a' },

      -- option toggle (mini.basics)
      { mode = 'n', keys = 'm' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers({ show_contents = true }),
      clue.gen_clues.windows({ submode_resize = true, submode_move = true }),
      clue.gen_clues.z(),
      { mode = 'n', keys = 'mm', desc = '+mini.map' },
    },
  })
end)

-- lsp
require('lsp')

-- 'mini.completion'
-- オートコンプリートを有効にする
now(function()
  require('mini.fuzzy').setup()
  require('mini.completion').setup({
    lsp_completion = {
      process_times = MiniFuzzy.process_lsp_times,
    },
    window = {
      info = { border = 'single' };
      signeture = { border = 'single' };
    }
  })

  -- 補間機能の改善
  vim.opt.complete = { '.', 'w', 'k', 'b', 'u' }
  vim.opt.completeopt:append('fuzzy')
  vim.opt.directory:append('/usr/share/dict/words') -- macOSの場合、ここに単語リストがある

  -- キーコードの定義
  local keys = {
    cn = vim.keycode('<c-n>'),
    cp = vim.keycode('<c-p>'),
    ct = vim.keycode('<c-t>'),
    cd = vim.keycode('<c-d>'),
    cr = vim.keycode('<cr>'),
    cy = vim.keycode('<c-y>'),
  }

  -- オートコンプリートの選択を<tab>/<s-tab>で行う
  vim.keymap.set('i', '<tab>', function()
    -- ポップアップが表示されている時は、次の選択肢
    -- ポップアップが表示されていない時は、インデントを追加
    return vim.fn.pumvisible() == 1 and keys.cn or keys.ct
  end, { expr = true, desc = 'Select next item if popup is visible' })

  vim.keymap.set('i', '<s-tab>', function()
    -- ポップアップが表示されている時は、前の選択肢
    -- ポップアップが表示されていない時は、インデントを追加
    return vim.fn.pumvisible() == 1 and keys.cp or keys.cd
  end, { expr = true, desc = 'Select previous item if popup is visible' })

  -- <cr>で確定
  vim.keymap.set('i', '<cr>', function()
    if vim.fn.pumvisible() == 0 then
      -- ポップアップが表示されていない時は、改行
      return require('mini.pairs').cr()
    end

    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    if item_selected then
      -- ポップアップが表示されていて、アイテムが選択されている場合は、それを確定する
      return keys.cy
    end

    -- ポップアップが表示されているが、アイテムが選択されていない場合、ポップアップを非表示に、改行する
    return keys.cy .. keys.cr
  end, { expr = true, desc = 'Complete current item if item is selected' })

  -- スニペットを有効にし、<c-k>でスニペットの項目にジャンプする
  require('mini.snippets').setup({
    mappings = {
      jump_prev = '<c-k>'
    },
  })
end)

-- 'mini.tabline'
-- 開いているバッファをタブでを表示する
later(function()
  require('mini.tabline').setup()
end)

-- 'mini.bufermove'
later(function()
  require('mini.bufremove').setup()

  -- vimのbdeleteはウィンドウごと削除してしまうのが不便なので、ウィンドウ構成を残したままバッファを削除するBufDeleteを定義
  vim.api.nvim_create_user_command(
    'BufDelete',
    function()
      MiniBufremove.delete()
    end,
    { desc = 'Remove Buffer' }
  )
end)

-- 'mini.files'
-- ファイラーモジュール
now(function()
  require('mini.files').setup({
    -- 'l' でファイルやディレクトリを開く
    -- 'h' で親ディレクトリへ移動する
    -- 行挿入で、新規ファイル作成（予約）
    -- 行コピーで、ファイルコピー（予約）
    -- 行削除で、ファイルを削除（予約）
    -- '=' で、予約した操作を確定する
    -- 'q' で終了
    -- 'g?' でヘルプ
    mappings = {
      close       = 'q',
      go_in       = 'l',
      go_in_plus  = '<cr>',
      go_out      = 'h',
      go_out_plus = 'H',
      mark_goto   = "'",
      mark_set    = 'm',
      reset       = '<BS>',
      reveal_cwd  = '@',
      show_help   = 'g?',
      synchronize = '=',
      trim_left   = '<',
      trim_right  = '>',
    },

    options = {
      permanent_delete = false
    }
  })

  vim.api.nvim_create_user_command(
    'Files',
    function()
      MiniFiles.open()
    end,
    { desc = 'Open file explorer' }
  )

  -- <space>e でも開く
  vim.keymap.set('n', '<space>e', '<cmd>Files<cr>', { desc = 'Open file explorer'})

end)

-- 'mini.pick'
-- Fussy Funder
later(function()
  require('mini.pick').setup()

  vim.ui.select = MiniPick.ui_select

  -- <cr> で開く
  -- <tab> でプレビュー
  -- <s-tab> でヘルプ
  -- <esc> で終了

  -- '<space>f' でファイルを検索する。
  -- tool = 'git' にすることで、git-lsfilesを使うようになる
  vim.keymap.set('n', '<space>f', function()
    MiniPick.builtin.files() -- ({ tool = 'git'})
  end, { desc = 'mini.pick files'})

  -- <space>b でバッファを検索する
  vim.keymap.set('n', '<space>b', function()
    local without_cur = function()
      vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
    end

    -- <c-d> でバッファを削除する
    local buffer_mappings = { without = { char = '<c-d>', func = without_cur } }
    MiniPick.builtin.buffers({ include_current = false }, { mappings = buffer_mappings })
  end, { desc = 'mini.pick.buffers' })
end)

-- 'mini.diff'
-- 差分を表示する
later(function()
  require('mini.diff').setup()
end)

-- 'mini.git'
-- later(function()
--   require('mini.git').setup()
--
--   vim.keymap.set({ 'n', 'x' }, '<space>gs', MiniGit.show_at_cursor, { desc = 'Show at cursor' })
-- end)

-- 'mini.operators'
-- later(function()
--   require('mini.operators').setup({
--     replace = { prefix = 'R' },
--     exchange = { prefix = '/' },
--   })
--
--   vim.keymap.set('n', 'RR', 'R', { desc = 'Replace mode' })
-- end)

-- 'mini.jump'
-- 'f' や 't' によるジャンプを強化する
-- 行を超えて、大文字小文字を無視したジャンプができるようになる
later(function()
  require('mini.jump').setup({
    delay = {
      idle_stop = 10,
    }
  })
end)

-- 'mini.jump2d'
-- 画面内のどこへでも直接jumpできる
later(function()
  require('mini.jump2d').setup()
end)

-- 'mini.animate'
-- スクロール時にアニメーションするようになる
-- later(function()
--   local animate = require('mini.animate')
--   animate.setup({
--     cursor = {
--       -- Animate for 100 milliseconds with linear easing
--       timing = animate.gen_timing.linear({ duration = 100, unit = 'total' }),
--     },
--     scroll = {
--       -- Animate for 150 milliseconds with linear easing
--       timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
--     }
--   })
-- end)

-- 'mini.bracketed'
-- '[' と ']' による移動を拡充する
later(function()
  require('mini.bracketed').setup()
end)

-- 'mini.splitjoin'
-- カッコのなかの要素をいい感じに改行したり、一行にまとめたりできる
later(function()
  require('mini.splitjoin').setup({
    mappings = {
      toggle = 'gS',
      split = 'ss',
      join = 'sj',
    },
  })
end)

-- 'mini.move'
-- later(function()
--   require('mini.move').setup()
-- end)

-- 'mini.align'
-- 一定のルールで文字列を並べ直す
-- ga で整列オペレーターを起動する
later(function()
  require('mini.align').setup()
end)

-- 'mini.map'
later(function()
  local map = require('mini.map')
  map.setup({
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diff(),
      map.gen_integration.diagnostic(),
    },
    symbols = {
      scroll_line = '▶',
    }
  })
  -- mmt でミニマップの表示をトグルする
  vim.keymap.set('n', 'mmt', MiniMap.toggle, { desc = 'MiniMap.toggle' })
  -- mmf で、ミニマップにフォーカスする
  vim.keymap.set('n', 'mmf', MiniMap.toggle_focus, { desc = 'MiniMap.toggle_focus' })
  -- mms で、ミニマップを左右移動させる
  vim.keymap.set('n', 'mms', MiniMap.toggle_side, { desc = 'MiniMap.toggle_side' })
end)

-- treesitter
now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
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

-- 検索して出てきたquickfixを直接編集することができる
-- '>' で、直前と直後の列を展開する
-- '<' で、展開したのを戻す
-- 'mq' で、quickfixを開いたり閉じたりする（トグル）
later(function()
  add({ source = 'https://github.com/stevearc/quicker.nvim' })
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

-- toggleterm plugin
now(function()
  add({ source = 'https://github.com/akinsho/toggleterm.nvim' })
  require('toggleterm').setup({
    size = 20,
    open_mapping = [[<c-t>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'horizontal',
    close_on_exit = true,
  })
end)

-- Vim内蔵のプラグインの読み読みを無効化するハック
-- この部分は、常にinit.luaの最後にある必要がある
now(function()
  local default_rtp = vim.opt.runtimepath:get()
  vim.opt.runtimepath:remove(vim.env.VIMRUNTIME)
  create_autocmd("SourcePre", {
    pattern = "*/plugin/*",
    once = true,
    callback = function()
      vim.opt.runtimepath = default_rtp
    end
  })
end)
