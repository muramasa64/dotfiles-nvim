return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'typescript' },
  root_dir = vim.fs.root(0, {'package.json', 'tsconfig.json', '.git'})
}
