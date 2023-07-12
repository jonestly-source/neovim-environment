-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- change color for arrows in tree to light blue
-- vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

-- configure nvim-tree
nvimtree.setup({
	-- change folder arrow icons
	sync_root_with_cwd = true,
	auto_reload_on_write = true,
	view = {
		width = 25,
		signcolumn = "no",
	},
	renderer = {
		indent_markers = {
			enable = true,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				bottom = "─",
				none = " ",
			},
		},
		-- filesystem_watchers = {
		-- 	enable = true,
		-- 	debounce_delay = 50,
		-- 	ignore_dirs = {},
		-- },
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "", -- arrow when folder is closed
					arrow_open = "", -- arrow when folder is open
				},
			},
		},
	},
	-- disable window_picker for
	-- explorer to work well with
	-- window splits
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
			quit_on_open = true,
		},
		change_dir = {
			enable = true,
			global = true,
			restrict_above_cwd = false,
		},
	},
	-- 	git = {
	-- 		ignore = false,
	-- 	},
})

local function open_nvim_tree(data)
	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not no_name and not directory then
		return
	end

	-- change to the directory
	if directory then
		vim.cmd.cd(data.file)
	end

	-- open the tree
	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
	pattern = "NvimTree*",
	callback = function()
		local def = vim.api.nvim_get_hl_by_name("Cursor", true)
		vim.api.nvim_set_hl(0, "Cursor", vim.tbl_extend("force", def, { blend = 100 }))
		vim.opt.guicursor:append("a:Cursor/lCursor")
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "WinClosed" }, {
	pattern = "NvimTree*",
	callback = function()
		local def = vim.api.nvim_get_hl_by_name("Cursor", true)
		vim.api.nvim_set_hl(0, "Cursor", vim.tbl_extend("force", def, { blend = 0 }))
		vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
	end,
})
