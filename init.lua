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
vim.opt.scrolloff = 9
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


-- renaming variables
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })


local Terminal = require('toggleterm.terminal').Terminal

local horizontal = Terminal:new({ id = 2, display_name = 'horizontal', direction = 'horizontal' })
local vertical   = Terminal:new({ id = 3, display_name = 'vertical',   direction = 'vertical' })
local float      = Terminal:new({ id = 4, display_name = 'float',      direction = 'float' })

vim.keymap.set('n', '<leader>th', function() horizontal:toggle() end, { desc = 'Toggle horizontal terminal' })
vim.keymap.set('n', '<leader>tv', function() vertical:toggle()   end, { desc = 'Toggle vertical terminal' })
vim.keymap.set('n', '<leader>tf', function() float:toggle()      end, { desc = 'Toggle float terminal' })

require('mini.pairs').setup()
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
vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Copy selection to system clipboard' })

-- moving lines up and down in visual mode 
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

require('neoscroll').setup({ mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>'} })
