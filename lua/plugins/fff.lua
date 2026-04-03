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
   keys = {
    { 'ff', function() require('fff').find_files() end, desc = 'FFFind files' },
    { 'fg', function() require('fff').live_grep() end, desc = 'LiFFFe grep' },
    { 'fz', function()
        require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } })
      end, desc = 'Live fffuzy grep' },
    { 'fc', function()
        require('fff').live_grep({ query = vim.fn.expand('<cword>') })
      end, desc = 'Search current word' },
  },
}
