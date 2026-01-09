return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yml' },

  on_attach = function(client, bufnr)
    if client.name == "yamlls" then
      client.server_capabilities.documentFormattingProvider = true
    end
  end,

  settings = {
    yaml = {
      format = {
        enable = true
      },
      schemaStore = {
        url = "https://www.schemastore.org/api/json/catalog.json",
        enable = true,
      },
      schemas = {
        ["https://squidfunk.github.io/mkdocs-material/schema.json"] = "mkdocs.yml",
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
      },
      customTags = {
        "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format",
        "tag:yaml.org,2002:python/name:material.extensions.emoji.twemoji",
        "tag:yaml.org,2002:python/name:material.extensions.emoji.to_svg",
        "tag:yaml.org,2002:python/name:pymdownx.emoji.twemoji",
      }
    }
  }
}

