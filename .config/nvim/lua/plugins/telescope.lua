return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>ps", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>pb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>pg", "<cmd>Telescope git_files<cr>", desc = "Help Tags" },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({})
  end,
}
