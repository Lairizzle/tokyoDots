local M = {}

-- ============================================================================
-- PALETTE
-- ============================================================================
M.palette = {
  background = '#271224', -- main background
  background_alt = '#291E37', -- floating windows
  foreground = '#6391D8', -- main text
  foreground_dim = '#7AA2F7', -- brighter for comments
  accent_primary = '#6391D8', -- main accent
  accent_secondary = '#493961', -- secondary accent
  accent_muted = '#3D355F', -- muted accent / visual selection
  purple_dark = '#BB9AF7', -- keywords (function/end/return)
  indigo_shadow = '#3D355F',
  plum_black = '#3B2A46',
  deep_maroon = '#361B30',
  error_red = '#F7768E',
  warning_yellow = '#E0AF68',
  info_cyan = '#73daca',
  hint_purple = '#BB9AF7',
}

-- ============================================================================
-- SETUP FUNCTION
-- ============================================================================
M.setup = function()
  local p = M.palette
  vim.o.background = 'dark'

  -- ===============================
  -- CORE HIGHLIGHT GROUPS
  -- ===============================
  vim.api.nvim_set_hl(0, 'Normal', { fg = p.foreground, bg = p.background })
  vim.api.nvim_set_hl(0, 'Comment', { fg = p.foreground_dim, italic = false })
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'Visual', { bg = p.accent_muted })

  vim.api.nvim_set_hl(0, 'Function', { fg = p.purple_dark, bold = true })
  vim.api.nvim_set_hl(0, 'Keyword', { fg = p.purple_dark, bold = true })
  vim.api.nvim_set_hl(0, 'Conditional', { fg = p.purple_dark, bold = true })
  vim.api.nvim_set_hl(0, 'Repeat', { fg = p.purple_dark, bold = true })
  vim.api.nvim_set_hl(0, 'Statement', { fg = p.purple_dark, bold = true })

  vim.api.nvim_set_hl(0, 'String', { fg = p.info_cyan })
  vim.api.nvim_set_hl(0, 'Character', { fg = p.info_cyan })
  vim.api.nvim_set_hl(0, 'Constant', { fg = p.warning_yellow })
  vim.api.nvim_set_hl(0, 'Number', { fg = p.warning_yellow })
  vim.api.nvim_set_hl(0, 'Boolean', { fg = p.accent_primary, bold = true })
  vim.api.nvim_set_hl(0, 'Identifier', { fg = p.accent_primary })
  vim.api.nvim_set_hl(0, 'Type', { fg = p.accent_secondary })
  vim.api.nvim_set_hl(0, 'Operator', { fg = p.accent_primary })
  vim.api.nvim_set_hl(0, 'Error', { fg = p.error_red, bold = true })

  -- ===============================
  -- FLOATING WINDOWS & POPUPS
  -- ===============================
  vim.api.nvim_set_hl(0, 'NormalFloat', { fg = p.foreground, bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = p.accent_secondary, bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'Pmenu', { fg = p.foreground, bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'PmenuSel', { fg = p.background, bg = p.accent_primary })
  vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = p.accent_primary })

  -- ===============================
  -- TELESCOPE
  -- ===============================
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { fg = p.foreground, bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = p.accent_secondary, bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = p.background, bg = p.accent_primary })
  vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { fg = p.foreground, bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = p.accent_secondary, bg = p.background_alt })
  vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { fg = p.accent_primary, bg = p.background_alt })

  -- ===============================
  -- LSP & DIAGNOSTICS
  -- ===============================
  vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = p.error_red })
  vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = p.warning_yellow })
  vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = p.info_cyan })
  vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = p.hint_purple })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = p.error_red })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = p.warning_yellow })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = p.info_cyan })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = p.hint_purple })
end

return M
