-- ===== Genel Ayarlar =====
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- ===== LSP Aktifleştirme (Neovim 0.11+) =====
-- Sisteminde bu LSP server'ların kurulu olması gerekir:
-- pyright, vscode-html-language-server,
-- vscode-css-language-server, typescript-language-server, clangd

vim.lsp.enable("pyright")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("clangd")

-- ===== Diagnostic Ayarları =====
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

-- ===== Hata İşaretleri (ikonlu) =====
vim.fn.sign_define("DiagnosticSignError", { text = " " })
vim.fn.sign_define("DiagnosticSignWarn",  { text = " " })
vim.fn.sign_define("DiagnosticSignHint",  { text = "󰠠 " })
vim.fn.sign_define("DiagnosticSignInfo",  { text = " " })

-- ===== Saydam Arkaplan =====
vim.cmd([[
  highlight Normal guibg=none ctermbg=none
  highlight NormalNC guibg=none ctermbg=none
  highlight SignColumn guibg=none ctermbg=none
  highlight LineNr guibg=none ctermbg=none
  highlight EndOfBuffer guibg=none ctermbg=none
]])

