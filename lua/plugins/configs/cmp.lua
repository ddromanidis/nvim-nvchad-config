local cmp = require "cmp"

dofile(vim.g.base46_cache .. "cmp")

local cmp_ui = require("core.utils").load_config().ui.cmp
local cmp_style = cmp_ui.style

local luasnip = require("luasnip")

-- Function to check if the cursor is inside an HTML tag
local function is_inside_html_tag()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]

  -- Check if cursor is inside a tag by matching '<...>' pattern
  return line:sub(col, col):match("<") and line:sub(col, col):match(">")
end

local alpinejs_snippets = {
  -- x-data snippet
  luasnip.s("x-data", {
    luasnip.text_node('x-data="{ '),
    luasnip.insert_node(1, "key: 'value'"),
    luasnip.text_node(' }"'),
  }, {
      condition = is_inside_html_tag
  }),

  -- x-bind snippet
  luasnip.s("x-bind", {
    luasnip.text_node('x-bind:'),
    luasnip.insert_node(1, "attribute"),
    luasnip.text_node('="'),
    luasnip.insert_node(2, "value"),
    luasnip.text_node('"'),
  }),

  -- x-on snippet
  luasnip.s("x-on", {
    luasnip.text_node('x-on:'),
    luasnip.insert_node(1, "event"),
    luasnip.text_node('="'),
    luasnip.insert_node(2, "handler"),
    luasnip.text_node('"'),
  }),

  -- x-model snippet
  luasnip.s("x-model", {
    luasnip.text_node('x-model="'),
    luasnip.insert_node(1, "variable"),
    luasnip.text_node('"'),
  }),

  -- x-show snippet
  luasnip.s("x-show", {
    luasnip.text_node('x-show="'),
    luasnip.insert_node(1, "condition"),
    luasnip.text_node('"'),
  }),

  -- x-if snippet
  luasnip.s("x-if", {
    luasnip.text_node('<template x-if="'),
    luasnip.insert_node(1, "condition"),
    luasnip.text_node('">'),
    luasnip.text_node('<div>'),
    luasnip.insert_node(2, "content"),
    luasnip.text_node('</div></template>'),
  }),

  -- x-for snippet
  luasnip.s("x-for", {
    luasnip.text_node('x-for="'),
    luasnip.insert_node(1, "item"),
    luasnip.text_node(' in '),
    luasnip.insert_node(2, "items"),
    luasnip.text_node('"'),
  }),

  -- x-transition snippet
  luasnip.s("x-transition", {
    luasnip.text_node('x-transition.'),
    luasnip.insert_node(1, "type"), -- e.g., "enter", "leave"
  }),

  -- x-cloak snippet
  luasnip.s("x-cloak", {
    luasnip.text_node('x-cloak'),
  }),

  -- x-ref snippet
  luasnip.s("x-ref", {
    luasnip.text_node('x-ref="'),
    luasnip.insert_node(1, "reference"),
    luasnip.text_node('"'),
  }),

  -- x-effect snippet
  luasnip.s("x-effect", {
    luasnip.text_node('x-effect="'),
    luasnip.insert_node(1, "expression"),
    luasnip.text_node('"'),
  }),

  -- x-init snippet
  luasnip.s("x-init", {
    luasnip.text_node('x-init="'),
    luasnip.insert_node(1, "expression"),
    luasnip.text_node('"'),
  }),
}

-- Alpine.js snippets
luasnip.add_snippets("templ", alpinejs_snippets)
luasnip.add_snippets("html", alpinejs_snippets)


local field_arrangement = {
  atom = { "kind", "abbr", "menu" },
  atom_colored = { "kind", "abbr", "menu" },
}

local formatting_style = {
  -- default fields order i.e completion word + item.kind + item.kind icons
  fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

  format = function(_, item)
    local icons = require "nvchad.icons.lspkind"
    local icon = (cmp_ui.icons and icons[item.kind]) or ""

    if cmp_style == "atom" or cmp_style == "atom_colored" then
      icon = " " .. icon .. " "
      item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
      item.kind = icon
    else
      icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
      item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
    end

    return item
  end,
}

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local options = {
  completion = {
    completeopt = "menu,menuone",
  },

  preselect = cmp.PreselectMode.None,

  window = {
    completion = {
      side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
      scrollbar = false,
    },
    documentation = {
      border = border "CmpDocBorder",
      winhighlight = "Normal:CmpDoc",
    },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = formatting_style,

  mapping = {
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<C-j>"] = cmp.mapping(function(fallback)
      -- if cmp.visible() then
      --   cmp.select_next_item()
      -- elseif require("luasnip").expand_or_jumpable() then
      --   vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      -- else
      --   fallback()
      -- end
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      -- if cmp.visible() then
      --   cmp.select_prev_item()
      -- elseif require("luasnip").jumpable(-1) then
      --   vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      -- else
      --   fallback()
      -- end
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
}

if cmp_style ~= "atom" and cmp_style ~= "atom_colored" then
  options.window.completion.border = border "CmpBorder"
end

return options
