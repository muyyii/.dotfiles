vim.api.nvim_set_keymap('n', ' ', '', {noremap = true})
vim.g.mapleader = ' '

-- vim.commands {{{
	local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
	local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
	local g = vim.g      -- a table to access global variables
	local opt = vim.opt  -- to set options
--- }}}

-- Plugins {{{

-- Autoinstall packer {{{
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  cmd 'packadd packer.nvim'
end
-- }}}

require('packer').startup(function()
-- Packer can manage itself
	use 'wbthomason/packer.nvim'

-- Essential Plugins
	--use 'scrooloose/nerdcommenter' -- plugin para comentar
	--use 'tpope/vim-surround' -- surround
	--use 'junegunn/fzf.vim' -- fuzzy finder

-- Colorschemes
	use 'tanvirtin/monokai.nvim'
	use 'shaunsingh/nord.nvim'

-- Colorizer
	use 'NvChad/nvim-colorizer.lua'

-- Font Icons
   	use 'kyazdani42/nvim-web-devicons'

-- Lua Plugins
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}  -- treesitter
	use {'nvim-lualine/lualine.nvim', requires = {'nvim-tree/nvim-web-devicons', opt=true}} -- statusline
	--use 'windwp/nvim-autopairs'
end)
-- }}}

-- General config {{{
	
	-- https://vimhelp.org/options.txt.html

	-- Color
	opt.termguicolors = true
		require('monokai').setup {}
	-- vim.cmd[[colorscheme nord]] -- TODO headlines support
	require 'colorizer'.setup()

	-- Change defaults
	opt.relativenumber = true  -- show line numbers
	opt.number         = true  -- but show the actual number for the line we're on

	opt.incsearch      = true  -- makes search act like search in modern browsers
	opt.showmatch      = true  -- show matching brackets when text indicator is over them
	opt.inccommand     = 'split' -- show live sustitution
	opt.cmdheight      = 1     -- height of the command bar
	opt.ignorecase     = true  -- ignore case when searching...
	opt.smartcase      = true  -- ... unless there is a capital letter in the query
	opt.hidden         = true  -- i like having buffers stay around
	opt.splitright     = true  -- prefer windows splitting to the right
	opt.splitbelow     = true  -- prefer windows splitting to the bottom
	opt.updatetime     = 1000  -- make updates happen faster
	opt.hlsearch       = false -- no highlight when search as default
	opt.scrolloff      = 7     -- make it so there are always ten lines below my cursor
	opt.foldlevel      = 99    -- don't fold if i don't say so
	opt.mouse		   = 'a'   -- use mouse
	opt.breakindent    = true  -- breaklines with tabs

	opt.linebreak      = true  -- Make Vim (soft-)break lines on withespace and other character

	-- Indent
	opt.autoindent     = true
	opt.tabstop        = 4
	opt.shiftwidth     = 4
	opt.expandtab      = false

	-- Lualine
	require('lualine').setup {
		options = {
			theme = 'nord'
		},
		sections = {
			lualine_a = {'mode'},
			lualine_b = {'branch', 'diff', 'diagnostics'},
			lualine_c = {'filename'},
    		lualine_x = {'filetype'},
    		lualine_y = {'progress'},
    		lualine_z = {'location'}
  		},
		tabline = {},
	}

	-- Treesitter
	require'nvim-treesitter.configs'.setup {
  	-- A list of parser names, or "all" (the five listed parsers should always be installed)
  	ensure_installed = {"glsl","r" ,"c", "lua", "vim", "vimdoc", "javascript", "rust", "markdown", "css", "html", "haskell" },

  	-- Install parsers synchronously (only applied to `ensure_installed`)
  	sync_install = false,

	-- Automatically install missing parsers when entering buffer
  	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  	auto_install = true,

  	-- List of parsers to ignore installing (for "all")
  	--ignore_install = { "javascript" },

  	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  	highlight = {
    	enable = true,

    	-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    	-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    	-- the name of the parser)
    	-- list of language that will be disabled
    	--disable = { "c", "rust" },
    	-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    	disable = function(lang, buf)
        	local max_filesize = 100 * 1024 -- 100 KB
        	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        	if ok and stats and stats.size > max_filesize then
            	return true
        	end
    	end,

    	-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    	-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    	-- Using this option may slow down your editor, and you may see some duplicate highlights.
    	-- Instead of true it can also be a list of languages
    	additional_vim_regex_highlighting = false,
  		},
	}

	-- nvim-web-devicons
	require'nvim-web-devicons'.setup {
 	-- your personnal icons can go here (to override)
 	-- you can specify color or cterm_color instead of specifying both of them
 	-- DevIcon will be appended to `name`
 	override = {
  		zsh = {
    		icon = "",
    		color = "#428850",
    		cterm_color = "65",
    		name = "Zsh"
  		}
 	};
 	-- globally enable different highlight colors per icon (default to true)
 	-- if set to false all icons will have the default icon's color
 	color_icons = true;
 	-- globally enable default icons (default to false)
 	-- will get overriden by `get_icons` option
 	default = true;
 	-- globally enable "strict" selection of icons - icon will be looked up in
 	-- different tables, first by filename, and if not found by extension; this
 	-- prevents cases when file doesn't have any extension but still gets some icon
 	-- because its name happened to match some extension (default to false)
 	strict = true;
	-- same as `override` but specifically for overrides by filename
 	-- takes effect when `strict` is true
 	override_by_filename = {
  	[".gitignore"] = {
    	icon = "",
    	color = "#f1502f",
    	name = "Gitignore"
  	}
 	};
 	-- same as `override` but specifically for overrides by extension
 	-- takes effect when `strict` is true
 	override_by_extension = {
  	["log"] = {
		icon = "",
    	color = "#81e043",
    	name = "Log"
  		}
 	};
	}

-- }}}

-- Mappings {{{
	local function map(mode, lhs, rhs, opts)
		local options = {noremap = true}
		if opts then options = vim.tbl_extend('force', options, opts) end
		vim.api.nvim_set_keymap(mode, lhs, rhs, options)
	end

	-- Yank and paste from clipboard
	--map('', '<leader>y', '"+y')
	--map('', '<leader>p', '"+p')

	-- Yank to end of the line
	--map('n', '<S-y>', 'y$')

	-- Open and select buffers
	--map('n', 'gb', ':ls<cr>:buffer<space>')

	-- Split navegation
	--map('n', '<C-j>', '<C-w>j')
	--map('n', '<C-k>', '<C-w>k')
	--map('n', '<C-h>', '<C-w>h')
	--map('n', '<C-l>', '<C-w>l')

	-- Sustitude/replace word under de cursor TODO: Pasar a lua
	--map('n', '<Leader>s', ':%s/\\<<C-r><C-w>\\>//<Left>')
-- }}}

-- vim:foldmethod=marker:foldlevel=0
