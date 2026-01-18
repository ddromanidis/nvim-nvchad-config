return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      -- require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  -- LSPCONFIG (Refactored for v2.5)
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- 1. Load NvChad's default LSP settings
      require("nvchad.configs.lspconfig").defaults()
      -- 2. Load your custom server configuration
      -- WARNING: You must create lua/configs/lspconfig.lua (see instructions below)
      require "configs.lspconfig"
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
    },
  },

  -- MASON (Tools installer)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls", "pyright", "rust-analyzer", "typescript-language-server",
        "eslint-lsp", "eslint_d", "prettier", "awk-language-server",
      },
    },
  },

  -- -- NONE-LS (Replacement for null-ls)
  {
    "nvimtools/none-ls.nvim",
    lazy = false,
    ft = { "go", "javascript", "typescript", "html", "css", "json" },
    opts = function()
      -- WARNING: You must create lua/configs/null-ls.lua
      return require "configs.null-ls"
    end,
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
  },

  -- DEBUGGING (DAP)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
       -- WARNING: You must create lua/configs/dap.lua
       -- require "configs.dap"
       -- NOTE: Old "load_mappings" removed. Put DAP keys in lua/mappings.lua
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      -- NOTE: Mappings moved to global mappings.lua
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },

  {
    "tpope/vim-fugitive",
    lazy = false,
  },

  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = { normal = "s" },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    config = function()
      local textobjects = require("nvim-treesitter-textobjects")
      -- A. Setup: Configure behavior (lookahead, etc)
      textobjects.setup({
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V',  -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
        },
        move = {
          set_jumps = true, -- Add to jumplist
        },
      })

      -- B. Keymaps: Manually define them now
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")
      local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")

      -- Helper to shorten lines
      local map = vim.keymap.set

      -- --- SELECT ---
      -- Functions
      map({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
      map({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
      -- Classes
      map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
      map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)
      -- Parameters (Arguments)
      map({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end)
      map({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end)

      -- --- SWAP ---
      map("n", "<leader>a", function() swap.swap_next("@parameter.inner") end)
      map("n", "<leader>A", function() swap.swap_previous("@parameter.inner") end)

      -- --- MOVE ---
      -- Jump to next function start/end
      map({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
      map({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end)
      -- Jump to prev function start/end
      map({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
      map({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end)

      -- --- REPEATABLE MOVES (; and ,) ---
      -- This allows you to use ; and , to repeat the last textobject move
      map({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move_next)
      map({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_previous)

      -- Optional: Make builtin f, F, t, T also repeatable with ; and ,
      map({ "n", "x", "o" }, "f", ts_repeat.builtin_f_expr, { expr = true })
      map({ "n", "x", "o" }, "F", ts_repeat.builtin_F_expr, { expr = true })
      map({ "n", "x", "o" }, "t", ts_repeat.builtin_t_expr, { expr = true })
      map({ "n", "x", "o" }, "T", ts_repeat.builtin_T_expr, { expr = true })
    end,
  },

  {
    "ddromanidis/newconstruct",
    ft = "go",
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
  },

  {
    "olimorris/codecompanion.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "gemini", model = "gemini-3-pro-preview" },
          inline = { adapter = "gemini", model = "gemini-3-pro-preview" },
          agent = { adapter = "gemini", model = "gemini-3-pro-preview" },
        },
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              schema = { model = { default = "gemini-3-pro-preview" } },
              env = { api_key = os.getenv("GEMINI_API_KEY") },
            })
          end,
        },
      })
    end,
  },

  {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup({
        terminals = {
          shell = vim.o.shell,
          type_opts = {
            float = {
              relative = 'editor',
              -- Centering logic: (1 - 0.8) / 2 = 0.1
              row = 0.1,
              col = 0.1,
              -- 80% size
              width = 0.8,
              height = 0.8,
              border = "single", -- Try "double" or "rounded" for better looks
            },
            horizontal = { location = "rightbelow", split_ratio = 0.3 },
            vertical = { location = "rightbelow", split_ratio = 0.5 },
          }
        },
        behavior = {
          autoclose_on_quit = { enabled = false, confirm = true },
          close_on_exit = true,
          auto_insert = true,
        },
      })
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = false,      -- false = Show files starting with .
        git_ignored = false,   -- false = Show files in .gitignore
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- The Go Adapter
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
      },
      -- Debugging Support
      "mfussenegger/nvim-dap",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local neotest = require("neotest")
      local neotest_golang = require("neotest-golang")

      -- Setup the Debugger first
      require("dap-go").setup()

      neotest.setup({
        adapters = {
          neotest_golang({
            -- CRITICAL FIX: Use standard "go" command to avoid the JSON error
            runner = "go",
            go_test_args = {
              "-v",
              "-race",
              -- "-count=1",
              -- "-timeout=60s",
              -- "--jsonfile=" .. report_path 
            },
            -- Enable Debugging (allows you to use <leader>td)
            dap_go_enabled = true,
          }),
        },

        -- UI Configuration
        output = {
          open_on_run = true, -- Auto-open output on failure
          enter = true,       -- Auto-focus the output window
        },
        status = {
          virtual_text = true, -- Show "Failed" text next to code
          signs = true,        -- Show Red/Green dots in gutter
        },
      })
    end,
    -- Keymaps for TDD
    keys = {
      { "<leader>t", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last Test" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary Tree" },
    },
  },

  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      -- This defines a sidebar on the RIGHT
      right = {
        -- 1. The Summary Tree (Top)
        {
          ft = "neotest-summary",
          title = "Tests",
          size = { height = 0.4, width = 50},
        },
        -- 2. The Output Panel (Bottom)
        {
          ft = "neotest-output-panel",
          title = "Output",
          size = { height = 0.6, width = 50},
        },
      },
      -- Optional: If you want to animate the window opening
      animate = {
        enabled = false,
      },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 4097,
    config = function()
        require("tiny-inline-diagnostic").setup({
          signs = {
              left = "",
              right = "",
              diag = "●",
              arrow = "    ",
              up_arrow = "    ",
              vertical = " │",
              vertical_end = " └",
          },
          blend = {
              factor = 0.22,
          },
        })
        vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = { diagnostics = { virtual_text = false } },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
