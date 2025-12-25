local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return {
  sources = {
    -- ===========================
    -- GO TOOLS
    -- ===========================
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.golines,

    -- ===========================
    -- WEB TOOLS (JS/TS/HTML)
    -- ===========================
    null_ls.builtins.formatting.prettier.with({
      filetypes = { 
        "javascript", "javascriptreact", "typescript", "typescriptreact", 
        "html", "json", "css", "sass"
      },
    }),

    -- ===========================
    -- ELIXIR TOOLS
    -- ===========================
    -- Auto-formatting (Standard)
    null_ls.builtins.formatting.mix,
    -- Linting / Code Style (Requires 'credo' in mix.exs)
    null_ls.builtins.diagnostics.credo,


    -- ESLINT (Requires none-ls-extras.nvim)
    require("none-ls.diagnostics.eslint"),
  },

  -- Format on Save logic
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end,
      })
    end
  end,
}
