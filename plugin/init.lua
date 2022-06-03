vim.api.nvim_create_user_command(
  'PotionMakerToggleTestFile',
  function() require'potion-maker'.toggle_test_file() end,
  {}
)
