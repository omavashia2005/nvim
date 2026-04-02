return {  
  'dmtrKovalenko/fff.nvim',  
  build = function()  
    -- Downloads prebuilt binary or builds from source using existing rustup toolchain  
    require("fff.download").download_or_build_binary()  
  end,  
  -- Optional configuration  
  opts = {  
    debug = {  
      enabled = true,     -- Enable during beta to help with development  
      show_scores = true, -- Show scoring to help optimize the system  
    },  
  },  
  -- No need to lazy-load - plugin initializes itself lazily  
  lazy = false,  
}
