return {  
  'kevinhwang91/nvim-ufo',  
  dependencies = 'kevinhwang91/promise-async',  
  event = 'VeryLazy',  
  config = function()  
    -- Required settings  
    vim.o.foldcolumn = '1'  
    vim.o.foldlevel = 99  
    vim.o.foldlevelstart = 99  
    vim.o.foldenable = true  
  
    -- Setup ufo  
    require('ufo').setup()  
  
    -- Key mappings  
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)  
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)  
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)  
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)  
  end,  
}
