-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 1 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(2)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


require("lazy").setup("plugins", {
  rocks = { enabled = false },
  checker = { enabled = true },
})

-- options
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hidden = true
vim.opt.fillchars:append({ eob = " " })

-- diagnostics
vim.diagnostic.config({
  virtual_text = {
    prefix = "■",
    spacing = 3,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})


require("fff")

-- keymaps
vim.keymap.set({ "n", "i", "v", "x", "s", "o", "c", "t" }, "<CapsLock>", "<Esc>", { desc = "Use Caps Lock as Escape" })
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

-- -- telescope (lazy loaded)
-- vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end)
-- vim.keymap.set("n", "<C-f>", function() require("telescope.builtin").live_grep() end)
-- vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end)
-- vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").lsp_references() end)
-- vim.keymap.set("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end)

-- split creation
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>")  -- vertical split
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>")   -- horizontal split
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>")   -- close split


-- renaming variables
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })


local Terminal = require('toggleterm.terminal').Terminal

local horizontal = Terminal:new({ id = 2, display_name = 'horizontal', direction = 'horizontal' })
local vertical   = Terminal:new({ id = 3, display_name = 'vertical',   direction = 'vertical' })
local float      = Terminal:new({ id = 4, display_name = 'float',      direction = 'float' })

vim.keymap.set('n', '<leader>th', function() horizontal:toggle() end, { desc = 'Toggle horizontal terminal' })
vim.keymap.set('n', '<leader>tv', function() vertical:toggle()   end, { desc = 'Toggle vertical terminal' })
vim.keymap.set('n', '<leader>tf', function() float:toggle()      end, { desc = 'Toggle float terminal' })

require('mini.pairs').setup({ mappings = { ["'"] = false } })
require("ibl").setup()
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "<C-d>", "<C-d>zz")

config = function()  
  require('ufo').setup({  
    provider_selector = function(bufnr, filetype, buftype)  
      return {'treesitter', 'indent'}  
    end  
  })  
end

vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all' })
-- vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Copy selection to system clipboard' })

vim.keymap.set({"n", "v"}, "y", '"+y')
vim.keymap.set("n", "yy", '"+yy')

-- moving lines up and down in visual mode 
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

-- require('neoscroll').setup({ mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>'} })

-- vim.opt.number = true
vim.opt.relativenumber = true

-- lol 
-- Disable arrow keys in Normal, Visual, and Select modes
vim.keymap.set({ 'n', 'v', 'x' }, '<Up>', '<nop>')
vim.keymap.set({ 'n', 'v', 'x' }, '<Down>', '<nop>')
vim.keymap.set({ 'n', 'v', 'x' }, '<Left>', '<nop>')
vim.keymap.set({ 'n', 'v', 'x' }, '<Right>', '<nop>')

-- Also disable in Insert mode (optional, but recommended for learning)
vim.keymap.set('i', '<Up>', '<nop>')
vim.keymap.set('i', '<Down>', '<nop>')
vim.keymap.set('i', '<Left>', '<nop>')
vim.keymap.set('i', '<Right>', '<nop>')

-- >>> viking
-- managed by viking setup
require('viking_overlay')
-- <<< viking
--
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})


vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format file or visual selection with Prettier" })

local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

local function text_format(symbol)
  local res = {}

  local round_start = { '', 'SymbolUsageRounding' }
  local round_end = { '', 'SymbolUsageRounding' }

  -- Indicator that shows if there are any other symbols in the same line
  local stacked_functions_content = symbol.stacked_count > 0
      and ("+%s"):format(symbol.stacked_count)
      or ''

  if symbol.references then
    local usage = symbol.references <= 1 and 'usage' or 'usages'
    local num = symbol.references == 0 and 'no' or symbol.references
    table.insert(res, round_start)
    table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
    table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
    table.insert(res, round_end)
  end

  if symbol.definition then
    if #res > 0 then
      table.insert(res, { ' ', 'NonText' })
    end
    table.insert(res, round_start)
    table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
    table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
    table.insert(res, round_end)
  end

  if symbol.implementation then
    if #res > 0 then
      table.insert(res, { ' ', 'NonText' })
    end
    table.insert(res, round_start)
    table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
    table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
    table.insert(res, round_end)
  end

  if stacked_functions_content ~= '' then
    if #res > 0 then
      table.insert(res, { ' ', 'NonText' })
    end
    table.insert(res, round_start)
    table.insert(res, { ' ', 'SymbolUsageImpl' })
    table.insert(res, { stacked_functions_content, 'SymbolUsageContent' })
    table.insert(res, round_end)
  end

  return res
end

require('symbol-usage').setup({
  text_format = text_format,
})
