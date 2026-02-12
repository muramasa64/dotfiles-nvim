MiniDeps.later(function()
  MiniDeps.add({ source = 'https://github.com/lambdalisue/nvim-aibo' })

  require('aibo').setup({
    submit_delay = 100,         -- Delay in milliseconds (default: 100)
    submit_key = '<CR>',        -- Key to send after submit (default: '<CR>')
    prompt_height = 10,         -- Prompt window height (default: 10)
    prompt_blend = 20,          -- Prompt window transparency 0-100, 0=opaque 100=transparent (default: 20)
    termcode_mode = 'hybrid',   -- Terminal escape sequence mode: 'hybrid', 'xterm', or 'csi-n' (default: 'hybrid')
    disable_startinsert_on_startup = false, -- Disable auto insert in prompt window when first opened (default: false)
    disable_startinsert_on_insert = false,  -- Disable auto insert in prompt when entering insert from console (default: false)

  --   -- Prompt buffer configuration
  --   prompt = {
  --     no_default_mappings = false,  -- Set to true to disable default keymaps
  --     on_attach = function(bufnr, info)
  --       -- Custom setup for prompt buffers
  --       -- Runs AFTER ftplugin files
  --       -- info.type = "prompt"
  --       -- info.tool = tool name (e.g., "claude")
  --       -- info.aibo = aibo instance
  --     end,
  --   },
  --
  --   -- Console buffer configuration
  --   console = {
  --     no_default_mappings = false,
  --     on_attach = function(bufnr, info)
  --       -- Custom setup for console buffers
  --       -- info.type = "console"
  --       -- info.cmd = command being executed
  --       -- info.args = command arguments
  --       -- info.job_id = terminal job ID
  --     end,
  --   },
  --
  --   -- Tool-specific overrides
  --   tools = {
  --     claude = {
  --       no_default_mappings = false,
  --       on_attach = function(bufnr, info)
  --         -- Custom setup for Claude buffers
  --         -- Called after prompt/console on_attach
  --       end,
  --     },
  --     codex = {
  --       -- Codex-specific configuration
  --     },
  --   },
  })
end)

