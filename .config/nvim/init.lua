-- colorschemes https://dotfyle.com/neovim/colorscheme/trending

-- Merge sign column with number column
-- vim.opt.signcolumn = "number"

vim.opt.conceallevel = 2

-- Enable true color support, allowing for more than 256 colors
vim.opt.termguicolors = true

-- Disable mode indication in command line. By default, Vim shows
-- "-- INSERT --", "-- VISUAL --", etc.
vim.opt.showmode = false

-- Set search to be case-sensitive only if the search pattern
-- contains uppercase characters
vim.opt.smartcase = true

-- Highlight the line where the cursor is currently positioned
vim.opt.cursorline = true

-- Display line numbers in the gutter
vim.opt.number = true

-- Display line numbers relative to the current line's position in
-- the gutter
vim.opt.relativenumber = true

-- Set the number of spaces used for each indentation level
vim.opt.shiftwidth = 2

-- Convert tabs into spaces

-- Automatically indent new lines to match the previous line's
-- indentation
vim.opt.smartindent = true

-- Enable line breaking at a convenient point (between words), not
-- exactly at the edge of the window
vim.opt.linebreak = true

-- Highlight matches as they are found when searching
vim.opt.incsearch = true

-- Allow for hidden buffers, meaning you can switch away from a
-- buffer without saving it
vim.opt.hidden = true

-- When splitting, put the new window to the right of the current
-- one
vim.opt.splitright = true

-- When splitting, put the new window below the current one
vim.opt.splitbelow = true

-- Disable the creation of backup files
vim.opt.backup = false

-- Set options for completion, including showing a menu of choices
-- and not selecting a match automatically
vim.opt.completeopt = { "menu" }

-- Set search to be case insensitive
vim.opt.ignorecase = true

-- Disable the creation of swap files
vim.opt.swapfile = false

-- Enable the creation of undo files, allowing changes to be
-- undone after exiting and restarting Vim
vim.opt.undofile = true

-- Set the time Vim waits before writing to the swap file to 100
-- milliseconds
vim.opt.updatetime = 100

-- Set the status line to display only for the current Neovim
-- instance. Only one status line is shown at the bottom
-- indicating the status of the current window.
vim.opt.laststatus = 0

-- Set the status line
vim.o.statusline = "%f " -- File path
  .. "%h%m%r " -- File status flags
  -- .. "[%{v:lua.git_branch()}] " -- Git branch
  .. "[%{getcwd()}]" -- Working directory

-- Set the maximum width for text that is being inserted. A longer
-- line will be broken after white space to get this width.
vim.opt.textwidth = 0

-- Disable the use of the mouse
vim.opt.mouse = ""

-- Show matching brackets when text indicator is over them
vim.opt.showmatch = true

-- Set the leader key to the space bar
vim.g.mapleader = " "

-- Disable automatic formatting options when entering a buffer
vim.cmd("autocmd BufEnter * set fo-=c fo-=r fo-=o")

-- Equalize window sizes when resizing
vim.api.nvim_create_autocmd("VimResized", {
  pattern = { "*" },
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Disable line numbers for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- This block configures diagnostic settings for Vim.
vim.diagnostic.config({
  -- When set to false, diagnostic messages won't be displayed in the virtual
  -- text area next to buffer text.
  virtual_text = false,

  -- If true, diagnostics are updated in insert mode. If false, diagnostics
  -- update only when you leave insert mode.
  update_in_insert = true,

  -- If true, sorts diagnostics by severity. This means the most severe issues
  -- will be shown first.
  severity_sort = true,

  -- This applies underlining to error-level diagnostics only.
  underline = { severity = vim.diagnostic.severity.ERROR },
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

require("paq")({
  "savq/paq-nvim",
  "nvim-lua/plenary.nvim",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "airblade/vim-rooter",
  "lewis6991/gitsigns.nvim",
  "sindrets/diffview.nvim",
  "neovim/nvim-lspconfig",
  "morhetz/gruvbox",
  "nvimtools/none-ls.nvim",
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },

  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-cmdline",

  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-path",
  "hrsh7th/nvim-cmp",
})

-- Telescope
vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>g", require("telescope.builtin").live_grep, {})
vim.keymap.set("n", "<leader>s", require("telescope.builtin").git_status, {})

-- Completion
local cmp = require("cmp")

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-i>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = "buffer" },
  }),
})

-- function _G.path_complete()
--   local col = vim.fn.col(".")
--   local line = vim.fn.getline(".")
--   local start_col = vim.fn.col(".") - 1
--   local match = vim.fn.matchstr(line:sub(1, start_col), "[^\\]*$")
--   return vim.fn.complete(start_col, vim.fn.globpath(vim.fn.getcwd(), match))
-- end
--
-- vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"
-- vim.api.nvim_set_option("completefunc", "v:lua.path_complete")
-- vim.api.nvim_set_keymap("i", "<C-i>", "<C-x><C-o>", { noremap = true, silent = true })

-- Null-ls
require("null-ls").setup({
  -- you can reuse a shared lspconfig on_attach callback here
  sources = {
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.formatting.prettier.with({}),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
          vim.lsp.buf.format({
            async = false,
            bufnr = bufnr,
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})

-- LSP
local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
require("cmp_nvim_lsp").default_capabilities(capabilities)

-- LSP Eslint
lspconfig.eslint.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      command = "EslintFixAll",
      buffer = bufnr,
    })
  end,
})

-- LSP TypeScript
lspconfig.tsserver.setup({ capabilities = capabilities })

-- LSP Tailwind
lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  filetypes = {
    "typescriptreact",
  },
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf })
    vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf })
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { buffer = ev.buf })
    vim.keymap.set("n", "<Leader>rf", vim.lsp.buf.references, { buffer = ev.buf })
    vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf })
  end,
})

-- Treesitter
-- TODO: Explore the plugin
require("nvim-treesitter.configs").setup({
  auto_install = true,
  ensure_installed = { "vimdoc", "lua", "vim", "html", "css", "javascript", "typescript", "tsx", "markdown" },
})

-- Gruvbox
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_contrast_light = "soft"
vim.g.gruvbox_sign_column = "bg0"
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_improved_warnings = 1
vim.g.gruvbox_italic = 1
-- vim.g.gruvbox_vert_split = "bg2"
vim.cmd("colorscheme gruvbox")
vim.cmd("set background=dark")

-- DiffView
local actions = require("diffview.actions")

require("diffview").setup({
  use_icons = false,
})

-- Miscelanneous
vim.keymap.set("n", "<Leader>wt", [[<Cmd>lvim '^##\+\s' % | lopen<CR>]])
vim.keymap.set("n", "<Leader>nt", [[<Cmd>lvim '^##\+\s' % | lopen<CR>]])
vim.keymap.set("n", "<Leader>E", vim.diagnostic.setqflist)

-- Git Signs

-- Text object
require("gitsigns").setup({
  on_attach = function()
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end)

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end)

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk)
    map("n", "<leader>hr", gitsigns.reset_hunk)
    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("n", "<leader>hS", gitsigns.stage_buffer)
    map("n", "<leader>hu", gitsigns.undo_stage_hunk)
    map("n", "<leader>hR", gitsigns.reset_buffer)
    map("n", "<leader>hp", gitsigns.preview_hunk)
    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end)
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
    map("n", "<leader>hd", gitsigns.diffthis)
    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end)
    map("n", "<leader>td", gitsigns.toggle_deleted)

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

    map("n", "<leader>Sl", gitsigns.toggle_linehl)
  end,
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "-" },
    topdelete = { text = "^" },
    changedelete = { text = "~" },
    untracked = { text = "!" },
  },
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 0,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  numhl = true,
  signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
})
