local M = {}

--- buffer-local 映射
-- @param bufnr number    缓冲区编号
-- @param mode  string   模式，如 "n"
-- @param lhs   string   按键
-- @param rhs   function | string  执行内容
-- @param opts  table?   额外选项 { desc=…, expr=… }
function M.buf_map(bufnr, mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { noremap = true, silent = true, buffer = bufnr }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M

