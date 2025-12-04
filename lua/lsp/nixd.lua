return {
  cmd = { 'nixd' },
  filetype = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> {}",
      },
      formatting = {
        command = { 'nixfmt' },
      },
    },
  },
}
