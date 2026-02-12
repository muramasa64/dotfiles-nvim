return {
  name = 'ruby_lsp',
  filetypes = { 'ruby' },
  cmd = {'ruby-lsp'},
  root_dir = vim.fs.dirname(vim.fs.find({ 'Gemfile', '.git' }, { upward = true })[1]),
  init_options = {
    formatter = 'standard',
    linters = { 'standard' },
  },
}
