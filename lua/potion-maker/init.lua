local M = {}

local get_current_file_path = function()
  return vim.api.nvim_exec(':echo expand("%p")', true)
end

local is_umbrella = function(file_path)
  return string.find(file_path, '^apps/') ~= nil
end

local is_test_file = function(file_path)
  local regex_expr

  if is_umbrella(file_path) then
    regex_expr = '^apps/([%w|_]+)/test/'
  else
    regex_expr = '^test/'
  end

  return string.find(file_path, regex_expr) ~= nil
end

M.get_toggle_test_file = function(file_path)
  local base_expression, replace

  if is_umbrella(file_path) then
    base_expression = '^(apps/[%w|_]+/)'
    replace = "%1"
  else
    base_expression = '^'
    replace = ""
  end

  local is_a_test_file = is_test_file(file_path)

  if is_a_test_file then
    base_expression = base_expression .. 'test'
    replace = replace .. 'lib'
  else
    base_expression = base_expression .. 'lib'
    replace = replace .. 'test'
  end

  local toggled_file = string.gsub(file_path, base_expression, replace)

  if is_a_test_file then
    toggled_file = string.gsub(toggled_file, '_test%.exs', '.ex')
  else
    toggled_file = string.gsub(toggled_file, '%.ex', '_test.exs')
  end

  return toggled_file
end

M.toggle_test_file = function()
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype ~= 'elixir' then
    error('PotionMaker only works for elixir files.')
  end

  local current_file = get_current_file_path()

  local toggled_file = M.get_toggle_test_file(current_file)

  vim.cmd(':e ' .. toggled_file, false)
  vim.cmd('silent exec "!mkdir -p %:h"', false)
end

return M
