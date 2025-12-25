local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      usePlaceholders = true, -- Add placeholders for function parameters
      analyses = {
        unusedparams = true, -- Warn about unused parameters
        nilness = true, -- Detect nil issues
        shadow = true, -- Detect variable shadowing
        fillstruct = true,
      },
      staticcheck = true,
    },
    gofumpt = true,
    linksInHover = false,
    templateExtensions = { "gohtml", "html", "templ" },
    codelenses = {
      generate = true, -- Enable `go generate` lens
      test = true, -- Enable test running lens
      gc_details = true, -- Show GC details
    },
  },
}

-- lspconfig.als.setup {
-- }
lspconfig.awk_ls.setup{
  settings = {
    awk = {
      lint = {
        -- Enable or disable linting (checking for errors).
        -- Type: boolean
        -- Default: true
        enabled = true,

        -- The command used for linting. You can change this to use a
        -- different awk implementation like 'nawk' or 'mawk'.
        -- The '-c' flag is for compatibility/compile mode in gawk.
        -- Type: string or array of strings
        -- Default: { "gawk", "-c", "-f" }
        command = { "gawk", "-c", "-f" },

        -- Time in milliseconds to wait after a change before linting.
        -- Type: number
        -- Default: 500
        debounce = 500,
      },

      format = {
        -- Enable or disable formatting.
        -- NOTE: The default awk language server formatting is very basic.
        -- You might prefer an external tool like 'gawk --pretty-print'.
        -- Type: boolean
        -- Default: true
        enabled = true,

        -- The command used for formatting.
        -- Type: string or array of strings
        -- Default: { "gawk", "-f" }
        command = { "gawk", "-f" },
      },

      trace = {
        -- For debugging the language server itself.
        -- Can be 'off', 'messages', or 'verbose'.
        -- Type: string
        -- Default: "off"
        server = "off",
      },
    }
  }
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
}

lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"css", "sass", "html", "gohtml", "templ"},
}

lspconfig.elixirls.setup {
  filetypes = { "elixir", "eelixir", "heex", "surface" },
  root_dir = lspconfig.util.root_pattern("mix.exs", ".git") or vim.loop.os_homedir(),
  cmd = { "~/.local/share/nvim/mason/bin/elixir-ls" },
}

vim.filetype.add({ extension = { templ = "templ" } })
local custom_format = function()
    if vim.bo.filetype == "templ" then
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local cmd = "templ fmt " .. vim.fn.shellescape(filename)

        vim.fn.jobstart(cmd, {
            on_exit = function()
                -- Reload the buffer only if it's still the current buffer
                if vim.api.nvim_get_current_buf() == bufnr then
                    vim.cmd('e!')
                end
            end,
        })
    else
        vim.lsp.buf.format()
    end
end
vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = vim.lsp.buf.format })
vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = custom_format })

lspconfig.templ.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ" },
})

lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ" },
})

lspconfig.htmx.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ" },
})

lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ", "astro", "javascript", "typescript", "react" },
    settings = {
      tailwindCSS = {
        includeLanguages = {
          templ = "html",
        },
      },
    },
})

lspconfig.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
})

lspconfig.volar.setup {}

lspconfig.eslint.setup({})

lspconfig.terraformls.setup({
  on_attach=on_attach,
  capabilities = capabilities,
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "tf", "terraform-vars" },
  root_dir = lspconfig.util.root_pattern(".terraform", ".git", "*.tf"),
  settings = {},
})

lspconfig.protols.setup {
  on_attach=on_attach,
  capabilities = capabilities,
  filetypes = { "proto" },
  root_dir = lspconfig.util.root_pattern(".terraform", ".git", "*.tf"),
}

-- lspconfig.volar.setup {
--   -- add filetypes for typescript, javascript and vue
--   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
--   init_options = {
--     vue = {
--       -- disable hybrid mode
--       hybridMode = false,
--     },
--     typescript = {
--       tsdk = vim.fn.expand(
--           "~/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib"
--       ),
--     }
--   },
-- }

lspconfig.emmet_language_server.setup({
  filetypes = { "css", "html", "javascript", "less", "sass", "scss", "pug", "typescriptreact", "gohtml", "templ" },
  -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
  -- **Note:** only the options listed in the table are supported.
  init_options = {
    ---@type table<string, string>
    includeLanguages = {},
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})

-- local configs = require("lspconfig.configs")
-- 
-- local lexical_config = {
--   filetypes = { "elixir", "eelixir", "heex", ".ex" },
--   cmd = {"/home/d/lexical/_build/dev/package/lexical/bin/start_lexical.sh"},
--   settings = {},
-- }
-- 
-- if not configs.lexical then
--   configs.lexical = {
--     default_config = {
--       filetypes = lexical_config.filetypes,
--       cmd = lexical_config.cmd,
--       root_dir = function(fname)
--         return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
--       end,
--       -- optional settings
--       settings = lexical_config.settings,
--     },
--   }
-- end
-- 
-- lspconfig.lexical.setup({})
