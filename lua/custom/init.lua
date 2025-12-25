local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.opt.colorcolumn = "90"

map('n', '<leader>ga', '<cmd>Git add .<CR>')
map('n', '<leader>gc', '<cmd>Git commit<CR>')
map('n', '<leader>gp', '<cmd>Git push<CR>')
map('n', '<leader>gh', '<cmd>diffget //3<CR>')
map('n', '<leader>gu', '<cmd>diffget //2<CR>')

map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')

map('n','<leader>q','<cmd>bp|sp|bn|bd<CR>')

map('n', '<leader>ie','<cmd>GoIfErr<CR>')

map('t', '<C-/>', '<C-\\><C-n>')

map("n", "<leader>ca", '<cmd>lua vim.lsp.buf.code_action, { noremap = true, silent = true }<CR>')

map("n", "{", '{{+')
map("n", "}", '}+')

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint'})

-- ~/.config/nvim/lua/custom/init.lua

-- Autocommand to enable spell checking for comments in various filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "c", "cpp", "go", "java", "javascript", "lua", "python",
    "rust", "typescript", "sh", "yaml", "toml", "json"
  },
  callback = function()
    -- Enable spell checking for the buffer
    vim.opt_local.spell = true

    -- Define Tree-sitter queries to control where spell checking occurs
    -- We are extending the existing highlighting queries
    vim.treesitter.query.set("highlights", "comment", "(comment) @spell")
    vim.treesitter.query.set("highlights", "string", "(string) @nospell")
  end,
  desc = "Enable spell checking for comments",
})
