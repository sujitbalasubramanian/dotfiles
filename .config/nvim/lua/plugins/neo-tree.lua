return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		-----Instead of using `config`, you can use `opts` instead, if you'd like:
		-----@module "neo-tree"
		-----@type neotree.Config
		--opts = {},
		config = function()
			vim.keymap.set("n", "<leader>e", "<Cmd>Neotree current<CR>")
		end,
	},
}
