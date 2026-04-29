
return {  
  'lewis6991/gitsigns.nvim',  
  opts = {  
    -- Your gitsigns configuration here  
		signs = {  
      add = { text = '┃' },  
      change = { text = '┃' },  
      delete = { text = '_' },  
      topdelete = { text = '‾' },  
      changedelete = { text = '~' },  
      untracked = { text = '┆' },  
    },  
    current_line_blame = false,  
    -- Add other options as needed  

  }  
}
