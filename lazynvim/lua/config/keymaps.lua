-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<tab>", ":BufferLineCycleNext<CR>")

vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("t", "<leader>t", [[<C-\><C-n>]], { noremap = true })
