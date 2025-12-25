require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- ============================================================================
--  GENERAL MAPPINGS
-- ============================================================================

-- INSERT MODE
-- Go to beginning and end
map("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "End of line" })

-- Navigate within insert mode
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- NORMAL MODE
map("n", "<Esc>", ":noh <CR>", { desc = "Clear highlights" })

-- Switch between windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- Save
map("n", "<C-s>", "<cmd> w <CR>", { desc = "Save file" })

-- Copy all
map("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy whole file" })

-- Line numbers
map("n", "<leader>n", "<cmd> set nu! <CR>", { desc = "Toggle line number" })
map("n", "<leader>rn", "<cmd> set rnu! <CR>", { desc = "Toggle relative number" })

-- Wrapped lines movement
map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })

-- New buffer / Cheatsheet
map("n", "<leader>b", "<cmd> enew <CR>", { desc = "New buffer" })
map("n", "<leader>ch", "<cmd> NvCheatsheet <CR>", { desc = "Mapping cheatsheet" })

-- LSP Formatting
map("n", "<leader>fm", function()
  vim.lsp.buf.format { async = true }
end, { desc = "LSP formatting" })

-- TERMINAL MODE
map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape terminal mode" })

-- VISUAL MODE
map("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("v", "<", "<gv", { desc = "Indent line" })
map("v", ">", ">gv", { desc = "Indent line" })
map("v", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text", silent = true })

-- X MODE (Visual Block)
map("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text", silent = true })

-- ============================================================================
--  PLUGIN MAPPINGS
-- ============================================================================

-- TABUFLINE
map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Goto next buffer" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Goto prev buffer" })

-- COMMENT
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

-- LSPCONFIG
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP implementation" })
map("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "LSP signature help" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "LSP definition type" })
map("n", "<leader>ra", function() require("nvchad.renamer").open() end, { desc = "LSP rename" })
map("n", "<leader>fs", function()
  vim.lsp.buf.code_action({ apply = true, context = { only = {"refactor.rewrite"} } })
end, { desc = "LSP code action (rewrite)" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP references" })
map("n", "<leader>f", function() vim.diagnostic.open_float { border = "rounded" } end, { desc = "Floating diagnostic" })
map("n", "[d", function() vim.diagnostic.goto_prev { float = { border = "rounded" } } end, { desc = "Goto prev" })
map("n", "]d", function() vim.diagnostic.goto_next { float = { border = "rounded" } } end, { desc = "Goto next" })
map("n", "<leader>x", vim.diagnostic.setloclist, { desc = "Diagnostic setloclist" })
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = "List workspace folders" })
map("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })

-- NVIMTREE
map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree" })
map("n", "<leader>e", "<cmd> NvimTreeFocus <CR>", { desc = "Focus nvimtree" })

-- TELESCOPE
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", { desc = "Find all" })
map("n", "<leader>fg", "<cmd> Telescope live_grep <CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd> Telescope buffers <CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "Help page" })
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>", { desc = "Find oldfiles" })
map("n", "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "Find in current buffer" })
map("n", "<leader>cm", "<cmd> Telescope git_commits <CR>", { desc = "Git commits" })
map("n", "<leader>gt", "<cmd> Telescope git_status <CR>", { desc = "Git status" })
map("n", "<leader>pt", "<cmd> Telescope terms <CR>", { desc = "Pick hidden term" })
map("n", "<leader>th", "<cmd> Telescope themes <CR>", { desc = "Nvchad themes" })
map("n", "<leader>o", function() require("base46").toggle_transparency() end, { desc = "Toggle transparency" })
map("n", "<leader>ma", "<cmd> Telescope marks <CR>", { desc = "telescope bookmarks" })

-- NVTERM (Ensure you have installed NvChad/nvterm in plugins/init.lua)
map({ "n", "t" }, "<A-i>", function() require("nvterm.terminal").toggle "float" end, { desc = "Toggle floating term" })
map({ "n", "t" }, "<A-v>", function() require("nvterm.terminal").toggle "horizontal" end, { desc = "Toggle horizontal term" })
map({ "n", "t" }, "<A-b>", function() require("nvterm.terminal").toggle "vertical" end, { desc = "Toggle vertical term" })
map("n", "<leader>h", function() require("nvterm.terminal").new "horizontal" end, { desc = "New horizontal term" })
map("n", "<leader>v", function() require("nvterm.terminal").new "vertical" end, { desc = "New vertical term" })

-- WHICHKEY
map("n", "<leader>wK", "<cmd> WhichKey <CR>", { desc = "Which-key all keymaps" })
map("n", "<leader>wk", function()
  local input = vim.fn.input "WhichKey: "
  vim.cmd("WhichKey " .. input)
end, { desc = "Which-key query lookup" })

-- GITSIGNS
map("n", "]c", function()
  if vim.wo.diff then return "]c" end
  vim.schedule(function() require("gitsigns").next_hunk() end)
  return "<Ignore>"
end, { desc = "Jump to next hunk", expr = true })

map("n", "[c", function()
  if vim.wo.diff then return "[c" end
  vim.schedule(function() require("gitsigns").prev_hunk() end)
  return "<Ignore>"
end, { desc = "Jump to prev hunk", expr = true })

map("n", "<leader>rh", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
map("n", "<leader>ph", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
map("n", "<leader>gb", function() package.loaded.gitsigns.blame_line() end, { desc = "Blame line" })
map("n", "<leader>td", function() require("gitsigns").toggle_deleted() end, { desc = "Toggle deleted" })

-- WARNING: Indent Blankline mapping removed.
-- The `indent_blankline.utils` module was removed in version 3.
-- This mapping will break your config if you keep it.

-- Git
map("n", "<leader>ga", "<cmd>Git add .<CR>", { desc = "Git add all" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
map("n", "<leader>gh", "<cmd>diffget //3<CR>", { desc = "Diffget right" })
map("n", "<leader>gu", "<cmd>diffget //2<CR>", { desc = "Diffget left" })

-- LSP Rename
map("n", "<leader>ar", vim.lsp.buf.rename, { desc = "LSP Rename" })

-- Buffer cleanup (Previous/Split/Next/Delete)
map("n", "<leader>q", "<cmd>bp|sp|bn|bd<CR>", { desc = "Close buffer and preserve layout" })

-- Go Error (requires your gopher plugin)
map("n", "<leader>ie", "<cmd>GoIfErr<CR>", { desc = "Go If Err" })

-- Terminal Escape
map("t", "<C-/>", "<C-\\><C-n>", { desc = "Escape terminal" })

-- Code Action (Fixed syntax error from your original file)
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

-- Movement tweaks
map("n", "{", "{{+", { desc = "Move up paragraph" })
map("n", "}", "}+", { desc = "Move down paragraph" })
