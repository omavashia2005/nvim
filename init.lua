-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
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
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- keymaps
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

-- telescope (lazy loaded)
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end)
vim.keymap.set("n", "<C-f>", function() require("telescope.builtin").live_grep() end)
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end)
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").lsp_references() end)
vim.keymap.set("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end)

-- split creation
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>")  -- vertical split
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>")   -- horizontal split
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>")   -- close split

-- moving lines up and down in visual mode 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- renaming variables
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })

-- for fff 
-- vim.keymap.set('n', 'ff', function() require('fff').find_files() end, { desc = 'FFFind files' })  
-- vim.keymap.set('n', 'fg', function() require('fff').live_grep() end, { desc = 'LiFFFe grep' })  
-- 
-- vim.keymap.set('n', 'fz', function()  
--   require('fff').live_grep({  
--     grep = {  
--       modes = { 'fuzzy', 'plain' }  
--     }  
--   })  
-- end, { desc = 'Live fffuzy grep' })  
-- 
-- 
-- vim.keymap.set('n', 'fc', function()  
--   require('fff').live_grep({ query = vim.fn.expand("<cword>") })  
-- end, { desc = 'Search current word' })

local Terminal = require('toggleterm.terminal').Terminal

local horizontal = Terminal:new({ id = 1, display_name = 'horizontal', direction = 'horizontal' })
local vertical   = Terminal:new({ id = 2, display_name = 'vertical',   direction = 'vertical' })
local float      = Terminal:new({ id = 3, display_name = 'float',      direction = 'float' })

vim.keymap.set('n', '<leader>th', function() horizontal:toggle() end, { desc = 'Toggle horizontal terminal' })
vim.keymap.set('n', '<leader>tv', function() vertical:toggle()   end, { desc = 'Toggle vertical terminal' })
vim.keymap.set('n', '<leader>tf', function() float:toggle()      end, { desc = 'Toggle float terminal' })

-- Cycle through open terminals (if you have several open)
vim.keymap.set('n', '<leader>t]', ':ToggleTermToggleAll<CR>',          { desc = 'Toggle all terminals' })
vim.keymap.set('n', '<leader>1',  '<cmd>1ToggleTerm<CR>',              { desc = 'Terminal 1' })
vim.keymap.set('n', '<leader>2',  '<cmd>2ToggleTerm<CR>',              { desc = 'Terminal 2' })
vim.keymap.set('n', '<leader>3',  '<cmd>3ToggleTerm<CR>',              { desc = 'Terminal 3' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Navigate out of any terminal split without closing it
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')


