--[[ NEOVIM CONFIGURATION ]]

-- ============================================================================
-- ENVIRONMENT SETUP
-- ============================================================================
vim.env.DOTNET_ROOT = '/usr/share/dotnet'
vim.env.PATH = vim.env.DOTNET_ROOT .. ':' .. vim.env.PATH:gsub('~', vim.fn.expand '~')

-- ============================================================================
-- LEADER KEYS
-- ============================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- ============================================================================
-- OPTIONS
-- ============================================================================
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.cursorline = true
opt.showmode = false
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Editing
opt.mouse = 'a'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'split'
opt.scrolloff = 10
opt.confirm = true

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2

-- Timing
opt.updatetime = 250
opt.timeoutlen = 300

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Clipboard (scheduled to reduce startup time)
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Floating windows
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE', fg = 'NONE' })

-- ============================================================================
-- KEYMAPS
-- ============================================================================
local keymap = vim.keymap.set

-- General
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })
keymap('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Editing helpers
keymap('n', '<leader>el', 'A;<Esc>', { desc = 'Add semicolon at end of line' })

-- Window navigation
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })

-- Buffer navigation
keymap({ 'n', 'v' }, '<tab>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })

-- LSP
keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- Debugging
keymap('n', '<leader>db', '<cmd>DapToggleBreakpoint<CR>', { desc = 'Toggle breakpoint' })
keymap('n', '<leader>dr', '<cmd>DapContinue<CR>', { desc = 'Start/continue debugger' })

-- Dotnet
keymap('n', '<leader>r', function()
  vim.cmd 'terminal dotnet run program'
end, { desc = 'Run dotnet program' })

-- Macro recording toggle
local recording = false
keymap('n', '<leader>ms', function()
  if not recording then
    vim.cmd 'normal! qa'
    recording = true
    print "Macro recording started in register 'a'"
  else
    vim.cmd 'normal! q'
    recording = false
    print 'Macro recording stopped'
  end
end, { desc = 'Toggle macro recording (register a)' })

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- AXAML filetype detection
autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.axaml',
  command = 'set filetype=axaml',
})

-- Disable semantic tokens (if needed for performance)
autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

-- ============================================================================
-- PLUGIN MANAGER (lazy.nvim)
-- ============================================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGINS
-- ============================================================================
require('lazy').setup({
  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'tokyonight'
    end,
  },

  -- Custom plugins
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
