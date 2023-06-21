local M = {}

M.manipulate_pipe = function(direction, client)
  local row = vim.fn.line('.') - 1
  local col = vim.fn.col('.') - 1
  local path = "file://" .. vim.api.nvim_buf_get_name(0)
  local args = { direction, path, row, col }

  client.request_sync("workspace/executeCommand", {
    command = "manipulatePipes:serverid",
    arguments = args,
  })
end

return M
