local M = {}

M._state = {
  mix_test_win = nil
}

local get_current_file_path = function()
  return vim.api.nvim_exec(':echo expand("%p")', true)
end

local is_umbrella = function(file_path)
  return string.find(file_path, '^apps/') ~= nil
end

local function file_exists(file_path)
  local f=io.open(file_path,"r")
  if f~=nil then io.close(f) return true else return false end
end

--- Returns if the file_path is a test or src file.
--@param file_path file path to test.
M.is_test_file = function(file_path)
  local regex_expr

  if is_umbrella(file_path) then
    regex_expr = '^apps/([%w|_]+)/test/'
  else
    regex_expr = '^test/'
  end

  return string.find(file_path, regex_expr) ~= nil
end

--- Returns the associated src/test file to the specified {file_path} file.
-- @param file_path file path of the file we want to switch from.
M.get_toggle_test_file = function(file_path)
  local base_expression, replace

  if is_umbrella(file_path) then
    base_expression = '^(apps/[%w|_]+/)'
    replace = "%1"
  else
    base_expression = '^'
    replace = ""
  end

  local is_a_test_file = M.is_test_file(file_path)

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

--- Switch between src and test file.
--If the file doesn't exist, it prompts a confirmation.
M.toggle_test_file = function()
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype ~= 'elixir' then
    error('PotionMaker only works for elixir files.')
  end

  local current_file = get_current_file_path()
  local toggled_file = M.get_toggle_test_file(current_file)

  if file_exists(toggled_file) then
    vim.cmd(':e ' .. toggled_file, false)
  else
    local msg = "File doesn't exist. Do you want to create it?"
    local response = vim.fn.confirm(msg, '&y\n&n', 1)

    if response == 1 then
      vim.cmd(':e ' .. toggled_file, false)
      vim.cmd('silent exec "!mkdir -p %:h"', false)
      vim.cmd('silent :w')
    end
  end
end

local execute_test = function(arg)
  if M._state.mix_test_win ~= nil and vim.fn.win_id2win(M._state.mix_test_win) ~= 0 then
    local winPos = vim.fn.win_id2win(M._state.mix_test_win)
    vim.cmd('silent exec ' .. winPos .. ".'wincmd c'")
  end

  vim.cmd('vsplit')
  vim.cmd(':term mix test ' .. arg)
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(buf, 'readonly', true)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<CMD>close<CR>', {})
  vim.api.nvim_buf_set_keymap(buf, 'n', 'i', '', {})
  M._state.mix_test_win = vim.fn.win_getid()
end

M.run_test_at_cursor = function()
  local current_file = get_current_file_path()

  if M.is_test_file(current_file) == false then
    vim.cmd('echo "Not a test file."')
    return
  end

  local current_line = vim.fn.line('.')

  execute_test(current_file .. ':' .. current_line)
end

M.run_test_for_current_file = function()
  local current_file = get_current_file_path()

  if M.is_test_file(current_file) == false then
    vim.cmd('echo "Not a test file."')
    return
  end

  execute_test(current_file)
end

return M
