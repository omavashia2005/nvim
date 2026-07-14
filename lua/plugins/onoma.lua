return {
	'ryanmab/onoma.nvim',

	version = '*', -- Required when using prebuilt binaries

	-- Otherwise, you can build from source
	-- build = 'cargo --config ./bridge/.cargo/config.toml build --release --manifest-path ./bridge/Cargo.toml'

	dependencies = {
		'folke/snacks.nvim',
	},
	event = 'VeryLazy',
	config = function()
		require('onoma').setup({
			-- Default configuration can be found in: "lua/config.lua"
			picker = { 'snacks' },
		})

		vim.keymap.set({ 'n', 'v', 'x' }, 'fs', Snacks.picker.get_symbols, { desc = 'Symbols', silent = true })
	end,
}
