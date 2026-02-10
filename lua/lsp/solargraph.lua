return {
  name = 'solargraph',
  filetypes = {'ruby'},
  cmd = {'solargraph', 'stdio'},
  root_dir = vim.fs.root(0, {'Gemfile', '.git'}),
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
  init_options = {
    formatting = true,
  },
}
