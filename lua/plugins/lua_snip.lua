return {
  	"L3MON4D3/LuaSnip",
	lazy = false,
	config = function()
	local ls = require("luasnip")
	    -- keymaps
	vim.keymap.set({"i", "s"}, "<Tab>", function()
		if ls.expand_or_jumpable() then
				ls.expand_or_jump()
		else
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
	      	end
	end)

	vim.keymap.set({"i", "s"}, "<S-Tab>", function()
		if ls.jumpable(-1) then ls.jump(-1) end
	end)
	
	ls.add_snippets("go", require("snippets.go"))
  	
	end,
}
