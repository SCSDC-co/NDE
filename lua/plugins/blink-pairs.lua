return {
	"saghen/blink.pairs",
	version = "*",

	dependencies = "saghen/blink.download",
	build = "cargo build --release",

	--- @module 'blink.pairs'
	--- @type blink.pairs.Config
	opts = {
		mappings = {
			enabled = true,
			pairs = {},
		},
		debug = false,
	},
}
