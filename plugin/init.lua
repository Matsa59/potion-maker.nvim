vim.api.nvim_create_user_command(
  'PotionMakerToggleTestFile',
  function() require'potion-maker'.toggle_test_file() end,
  {}
)

vim.api.nvim_create_user_command(
  'PotionMakerExecuteTestAtCursor',
  function() require'potion-maker'.run_test_at_cursor() end,
  {}
)

vim.api.nvim_create_user_command(
  'PotionMakerExecuteTestForCurrentFile',
  function() require'potion-maker'.run_test_for_current_file() end,
  {}
)
