MiniDeps.later(function()
  MiniDeps.add({ source = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })

  local render_markdown = require('render-markdown')
  render_markdown.setup({})

  vim.keymap.set('n', 'mmt', render_markdown.toggle, { desc = 'RenderMarkdown.toggle' })
  vim.keymap.set('n', 'mmb', render_markdown.buf_toggle, { desc = 'RenderMarkdown.buf_toggle' })
  vim.keymap.set('n', 'mmp', render_markdown.preview, { desc = 'RenderMarkdown.preview' })
end)

