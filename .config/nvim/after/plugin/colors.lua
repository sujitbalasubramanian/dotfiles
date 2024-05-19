function ColorMyPencils(color)
	color = color or "gruvbox"
	vim.cmd.colorscheme(color)
    -- vim.opt.bg="light"

    -- bg transparency
	-- vim.api.nvim_set_hl(0,"Normal", {bg = "none"})
	-- vim.api.nvim_set_hl(0,"Normal", {bg = "none"})
end

ColorMyPencils()
