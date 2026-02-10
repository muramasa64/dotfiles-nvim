return {
  name = "tofu-ls",
  cmd = { 'tofu-ls', 'serve' },
  filetypes = { 'terraform', 'terraform-vars' },
  root_dir = vim.fs.root(0, {"terraform", ".git"}),
}
