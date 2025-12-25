-- lua/configs/lspconfig.lua
-- STRICTLY FOR NEOVIM v0.11+ (Nightly)

-- 1. LOAD NVCHAD CORE DEFAULTS
local nvlsp = require "nvchad.configs.lspconfig"
local capabilities = nvlsp.capabilities

-- ============================================================================
-- 2. SETUP HELPERS (The "New Way")
-- ============================================================================

-- A. Global Handler for "on_attach" (Runs for ALL servers)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Run NvChad's default on_attach (keys, UI, etc)
    nvlsp.on_attach(client, args.buf)
    if nvlsp.on_init then nvlsp.on_init(client, args.buf) end
  end,
})

-- B. Helper function to configure & enable servers
local function setup(server, config)
  config = config or {}
  
  -- Merge NvChad's capabilities (autocompletion support)
  config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})

  -- Assign to the new native vim.lsp.config table
  -- We merge with any existing config (from nvim-lspconfig defaults)
  local existing = vim.lsp.config[server] or {}
  vim.lsp.config[server] = vim.tbl_deep_extend("force", existing, config)

  -- Enable the server
  vim.lsp.enable(server)
end

-- ============================================================================
-- 3. SERVER CONFIGURATIONS
-- ============================================================================

-- GOPLS
setup("gopls", {
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl"},
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        nilness = true,
        shadow = true,
        fillstruct = true,
      },
      staticcheck = true,
    },
    gofumpt = true,
    linksInHover = false,
    templateExtensions = { "gohtml", "html", "templ" },
    codelenses = {
      generate = true,
      test = true,
      gc_details = true,
    },
  },
})

-- AWK
setup("awk_ls", {
  settings = {
    awk = {
      lint = { enabled = true, command = { "gawk", "-c", "-f" } },
      format = { enabled = true, command = { "gawk", "-f" } },
      debounce = 500,
      trace = { server = "off" },
    }
  }
})

-- PYRIGHT
setup("pyright", {
  filetypes = {"python"},
})

-- CSSLS
setup("cssls", {
  filetypes = {"css", "sass", "html", "gohtml", "templ"},
})

-- ELIXIR
setup("elixirls", {
  cmd = { "elixir-ls" },
  filetypes = { "elixir", "eelixir", "heex", "surface" },
  root_markers = { "mix.exs", ".git" },
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = false,
    }
  }
})

-- TEMPL
setup("templ", {
  filetypes = { "html", "templ" },
})

-- HTML
setup("html", {
  filetypes = { "html", "templ", "heex" },
})

-- HTMX
setup("htmx", {
  filetypes = { "html", "templ" },
})

-- TAILWIND
setup("tailwindcss", {
  filetypes = { "html", "templ", "astro", "javascript", "typescript", "react", "elixir", "eelixir", "heex" },
  init_options = {
    userLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex",
    },
  },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        templ = "html",
      },
    },
  },
})

-- TYPESCRIPT / VUE
setup("ts_ls", {
  filetypes = { "javascript", "typescript", "vue" },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
})

setup("vue_ls", {})
setup("eslint", {})

-- TERRAFORM
setup("terraformls", {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "tf", "terraform-vars" },
  root_markers = { ".terraform", ".git", "*.tf" },
})

-- PROTOBUF
setup("protols", {
  filetypes = { "proto" },
  root_markers = { ".git", "*.proto" },
})

-- EMMET
setup("emmet_language_server", {
  filetypes = { "css", "html", "javascript", "less", "sass", "scss", "pug", "typescriptreact", "gohtml", "templ", "heex" },
  init_options = {
    includeLanguages = {},
    excludeLanguages = {},
    extensionsPath = {},
    preferences = {},
    showAbbreviationSuggestions = true,
    showExpandedAbbreviation = "always",
    showSuggestionsAsSnippets = false,
    syntaxProfiles = {},
    variables = {},
  },
})

-- ============================================================================
-- 4. CUSTOM FORMATTING LOGIC (Templ)
-- ============================================================================

vim.filetype.add({ extension = { templ = "templ" } })

local custom_format = function()
    if vim.bo.filetype == "templ" then
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local cmd = "templ fmt " .. vim.fn.shellescape(filename)

        vim.fn.jobstart(cmd, {
            on_exit = function()
                -- Reload buffer if it's still current
                if vim.api.nvim_get_current_buf() == bufnr then
                    vim.cmd('e!')
                end
            end,
        })
    else
        vim.lsp.buf.format()
    end
end

-- Re-add your formatting autocommands
vim.api.nvim_create_autocmd({ "BufWritePre" }, { 
  pattern = { "*.templ" }, 
  callback = vim.lsp.buf.format 
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, { 
  pattern = { "*.templ" }, 
  callback = custom_format 
})
