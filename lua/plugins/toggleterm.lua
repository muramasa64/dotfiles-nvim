-- toggleterm plugin
MiniDeps.now(function()
  MiniDeps.add({ source = 'https://github.com/akinsho/toggleterm.nvim' })
  require('toggleterm').setup({
    size = 50,
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

