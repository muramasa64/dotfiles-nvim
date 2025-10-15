-- keymaps
-- pを使ってペーストした時に、カーソルをペースト末尾に移動させる
vim.keymap.set('n', 'p', 'p`]', { desc = 'Paste and move to the end' })
vim.keymap.set('n', 'P', 'P`]', { desc = 'Paste and move to the end' })
-- visual modeでpでペーストするとレジスタがペースト範囲に変わり、Pはその逆となる
-- この動作を逆にする設定
vim.keymap.set('x', 'p', 'P', { desc = 'Paste without change register' })
vim.keymap.set('x', 'P', 'p', { desc = 'Paste with change register' })
-- xまたはXを使って、dまたはDと同じ動作にし、かつ、削除したものをblackholeレジスタに入れる
-- vim.keymap.set({ 'n', 'x' }, 'x', '"_d', { desc = 'Delete using blackhole register' })
-- vim.keymap.set('n', 'X', '"_D', { desc = 'Delete using blackhole register' })
-- vim.keymap.set('o', 'x', 'd', { desc = 'Delete using x' })
-- コマンドモードで、Emacsライクなカーソル移動が使えるようにする
vim.keymap.set('c', '<c-b>', '<left>', { desc = 'Emacs like left' })
vim.keymap.set('c', '<c-f>', '<right>', { desc = 'Emacs like right' })
vim.keymap.set('c', '<c-a>', '<home>', { desc = 'Emacs like home' })
vim.keymap.set('c', '<c-e>', '<end>', { desc = 'Emacs like end' })
vim.keymap.set('c', '<c-h>', '<bs>', { desc = 'Emacs like bs' })
vim.keymap.set('c', '<c-d>', '<del>', { desc = 'Emacs like del' })
-- <space>; で直前のマクロを実行する
vim.keymap.set('n', '<space>;', '@:', { desc = 'Re-run the last command' })
-- <space>w でファイルを保存する
vim.keymap.set('n', '<space>w', '<cmd>write<cr>', { desc = 'Write' })
-- so で現在開いている設定を再読み込みする
vim.keymap.set({ 'n', 'x' }, 'so', ':source<cr>', { silent = true, desc = 'Source current script' })
-- コマンド履歴を呼び出す <c-p>と<up>は微妙に挙動が異なるので同じにしてしまう
vim.keymap.set('c', '<c-n>', function()
  return vim.fn.wildmenumode() == 1 and '<c-n>' or '<down>'
end, { expr = true, desc = 'Select next' })
vim.keymap.set('c', '<c-p>', function()
  return vim.fn.wildmenumode() == 1 and '<c-p>' or '<up>'
end, { expr = true, desc = 'Select previous' })
-- <space>q でタブを閉じる
vim.keymap.set('n', '<space>q', function()
  if not pcall(vim.cmd.tabclose) then
    vim.cmd.quit()
  end
end, { desc = 'Quit current tab or window' })
