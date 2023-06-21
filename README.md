# potion-maker.nvim

Be an alchemist on neovim.

## Intallation

### Using Lazy.nvim

```lua
  {
    'matsa59/potion-maker.nvim',
    dev = true,
    keys = {
      { "<leader>mfp", "<cmd>PotionMakerFunctionPipe<cr>", desc = "Pipe to function" },
      { "<leader>mfu", "<cmd>PotionMakerFunctionUnpipe<cr>", desc = "Unpipe from function" },
      { "<leader>mtt", "<cmd>PotionMakerToggleTestFile<cr>", desc = "Switch between test and source file" },
      { "<leader>mts", "<cmd>PotionMakerExecuteTestAtCursor<cr>", desc = "Run test at cursor position" },
      { "<leader>mtS", "<cmd>PotionMakerExecuteTestForCurrentFile<cr>", desc = "Run every test in current file" },
    },
  },
```

### From/To pipe

It requires to bind the lsp client to potion-maker

If you have a custom installation you can do:

```lua
require('lspconfig').elixirls.setup {
  capabilities = capabilities,
  cmd = { server_config.elixirls..'/language_server.sh' },
  on_attach = function (...)
    require('potion-maker').on_attach(...)
    -- your others handlers
  end
}
```

