local servers = 
	{ 
		"lua_ls", 
		"pyright", 
		"gopls", 
		"ts_ls", 
		"clangd",  
		"docker_language_server", 
		"dockerls", 
		"docker_compose_language_service",
	}

return {
  {
    "mason-org/mason.nvim",
    opts = {},
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = servers,
	}
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {})
        vim.lsp.enable(server)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
	vim.keymap.set({'n'}, '<space>ca', vim.lsp.buf.code_action, {})
      end
    end,
  },
}

