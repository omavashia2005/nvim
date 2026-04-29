return {  
  "sindrets/diffview.nvim",  
  dependencies = { "nvim-lua/plenary.nvim" },  
  config = function()  
    require("diffview").setup({  
      -- Focus on merge conflict configuration  
      view = {  
        merge_tool = {  
          -- Default layout for merge conflicts (3-way horizontal)  
          layout = "diff3_horizontal",  
          -- Disable diagnostics during conflict resolution  
          disable_diagnostics = true,  
          -- Show additional info in winbar  
          winbar_info = true,  
        },  
      },  
    })  
  end,  
}
