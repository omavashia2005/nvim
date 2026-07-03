-- Viking plugin (managed by viking setup; safe to edit but constants are read by the setup script).
local M = {}

-- >>> viking-constants (do not edit by hand)
M.app_path = '/Users/omavashia/viking/release/mac-arm64/Viking.app'
M.keymap   = '<leader>vo'
-- <<< viking-constants

M.state = 'opened'
local seen = {}
local seen_count = 0

local function on_buf_enter()
  -- buftype == '' filters out quickfix, help, terminal, prompt buffers.
  if vim.bo.buftype ~= '' then return end
  local name = vim.api.nvim_buf_get_name(0)
  if name == '' then return end
  if not seen[name] then
    seen[name] = true
    seen_count = seen_count + 1
  end
  M.state = seen_count >= 2 and 'multiple files open' or 'opened'
end

-- Dedicated augroup so re-sourcing the file doesn't stack autocmds.
local group = vim.api.nvim_create_augroup('viking', { clear = true })

vim.api.nvim_create_autocmd('BufEnter',    { group = group, callback = on_buf_enter })
vim.api.nvim_create_autocmd('InsertEnter', { group = group, callback = function() M.state = 'received' end })
vim.api.nvim_create_autocmd('InsertLeave', { group = group, callback = function()
  if M.state == 'received' then M.state = 'escaped' end
end })
-- VimLeavePre runs before the process exits; VimLeave is too late for any user-visible work.
vim.api.nvim_create_autocmd('VimLeavePre', { group = group, callback = function()
  if M.state == 'received' then M.state = 'quit' end
end })

-- Invoke the binary directly (not `open -a`) so Electron's single-instance
-- lock observes the second invocation and routes its argv via 'second-instance'.
-- `open -a` on macOS reuses the running process without re-entering main().
local function binary_path()
  local app = M.app_path
  if app:sub(-4) == '.app' then
    return app .. '/Contents/MacOS/' .. vim.fn.fnamemodify(app, ':t:r')
  end
  return app
end

-- Bound in insert + normal so the user can fire from either; state machine becomes advisory.
vim.keymap.set({ 'i', 'n' }, M.keymap, function()
  -- detach so the child outlives nvim; jobstart with a list argv avoids shell quoting.
  vim.fn.jobstart({ binary_path(), '--args', vim.fn.getcwd(), vim.fn.expand('%:p') }, { detach = true })
end, { desc = 'viking: send cwd + filename to app' })

return M
