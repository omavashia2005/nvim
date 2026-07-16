-- Viking plugin (managed by viking setup; safe to edit but constants are read by the setup script).
local M = {}

-- >>> viking-constants (do not edit by hand)
M.app_path = '/Users/omavashia/viking/release/mac-arm64/Viking.app'
M.keymap   = '<leader>vo'
-- <<< viking-constants

M.state = 'opened'
M.log_path = vim.fn.stdpath('state') .. '/viking.log'
local seen = {}
local seen_count = 0

local function log(line)
  vim.fn.mkdir(vim.fn.fnamemodify(M.log_path, ':h'), 'p')
  local f = io.open(M.log_path, 'a')
  if not f then return end
  f:write(os.date('%Y-%m-%d %H:%M:%S') .. ' [nvim] ' .. line .. '\n')
  f:close()
end

local function set_state(next, reason)
  if M.state ~= next then
    log(('state %s -> %s (%s)'):format(M.state, next, reason))
  end
  M.state = next
end

local function shell_join(argv)
  local escaped = {}
  for i, value in ipairs(argv) do
    escaped[i] = vim.fn.shellescape(value)
  end
  return table.concat(escaped, ' ')
end

local function on_buf_enter()
  -- buftype == '' filters out quickfix, help, terminal, prompt buffers.
  if vim.bo.buftype ~= '' then return end
  local name = vim.api.nvim_buf_get_name(0)
  if name == '' then return end
  if not seen[name] then
    seen[name] = true
    seen_count = seen_count + 1
  end
  set_state(seen_count >= 2 and 'multiple files open' or 'opened', 'BufEnter ' .. name)
end

-- Dedicated augroup so re-sourcing the file doesn't stack autocmds.
local group = vim.api.nvim_create_augroup('viking', { clear = true })

vim.api.nvim_create_autocmd('BufEnter',    { group = group, callback = on_buf_enter })
vim.api.nvim_create_autocmd('InsertEnter', { group = group, callback = function()
  set_state('received', 'InsertEnter')
end })
vim.api.nvim_create_autocmd('InsertLeave', { group = group, callback = function()
  if M.state == 'received' then set_state('escaped', 'InsertLeave') end
end })
-- VimLeavePre runs before the process exits; VimLeave is too late for any user-visible work.
vim.api.nvim_create_autocmd('VimLeavePre', { group = group, callback = function()
  if M.state == 'received' then set_state('quit', 'VimLeavePre') end
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
  local cwd = vim.fn.getcwd()
  local active_file = vim.fn.expand('%:p')
  local argv = { binary_path(), '--args', cwd, active_file }
  local shell_cmd = shell_join(argv) .. ' >> ' .. vim.fn.shellescape(M.log_path) .. ' 2>&1'
  log(('keymap fired state=%s cwd=%s file=%s'):format(M.state, cwd, active_file ~= '' and active_file or '<none>'))
  log('spawn ' .. shell_cmd)
  local job = vim.fn.jobstart({ '/bin/sh', '-c', shell_cmd }, { detach = true })
  if job <= 0 then
    log('jobstart failed code=' .. tostring(job))
    vim.api.nvim_err_writeln('[viking] launch failed; see ' .. M.log_path)
    return
  end
  vim.api.nvim_out_write('[viking] logged to ' .. M.log_path .. '\n')
  log('jobstart ok job=' .. tostring(job))
end, { desc = 'viking: send cwd + filename to app' })

log(('plugin loaded keymap=%s app=%s log=%s'):format(M.keymap, M.app_path, M.log_path))

return M
