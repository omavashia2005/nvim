return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master', 
  lazy = false, 
  build = ":TSUpdate", 
  config = function()
    require'nvim-treesitter.configs'.setup
    {
    ensure_installed = {"lua", "javascript", "python", "java", "go", "c", "dockerfile", "css", "html"},
    highlight = {enable = true},
    indent = {enable = true},
    }
  end
}

