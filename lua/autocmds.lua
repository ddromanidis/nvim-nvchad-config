require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- 1. Enable spell checking for comments in specific languages
autocmd("FileType", {
  pattern = {
    "c", "cpp", "go", "java", "javascript", "lua", "python",
    "rust", "typescript", "sh", "yaml", "toml", "json"
  },
  callback = function()
    vim.opt_local.spell = true
    -- Extend treesitter highlighting for comments
    -- Note: This requires vim.treesitter.query to be available
    pcall(function() 
        vim.treesitter.query.set("highlights", "comment", "(comment) @spell") 
        vim.treesitter.query.set("highlights", "string", "(string) @nospell")
    end)
  end,
  desc = "Enable spell checking for comments",
})

-- 2. Set terminal title to current folder name
autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    vim.opt.titlestring = dir
    vim.opt.title = true
  end,
})

-- 3. Clear title on exit
autocmd("VimLeave", {
  pattern = "*",
  callback = function()
    vim.opt.title = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "mix.exs",
  callback = function()
    -- Use a non-blocking job so your editor doesn't freeze
    vim.fn.jobstart("mix deps.get", {
      stdout_buffered = true,
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("✅ mix deps.get installed successfully", vim.log.levels.INFO)
        else
          vim.notify("❌ mix deps.get failed", vim.log.levels.ERROR)
        end
      end,
    })
  end,
  desc = "Auto-install Elixir deps on save",
})
