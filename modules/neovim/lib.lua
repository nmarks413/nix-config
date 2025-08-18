-- Ported from https://www.reddit.com/r/neovim/comments/vemydn
vim.api.nvim_create_user_command("FullscreenTerm", function(opts)
	vim.cmd("tab terminal " .. opts.args)
	local laststatus = vim.o.laststatus
	local showtabline = vim.o.showtabline
	local cmdheight = vim.o.cmdheight
	vim.o.laststatus = 0
	vim.o.cmdheight = 0
	vim.o.showtabline = 0
	vim.wo.signcolumn = "no"
	vim.wo.relativenumber = false
	vim.wo.number = false
	vim.cmd(
		"autocmd! TermClose <buffer=abuf> "
			.. "if !v:event.status"
			.. " | exec 'bd! '..expand('<abuf>')"
			.. " | endif"
			.. " | checktime"
			.. " | set laststatus="
			.. laststatus
			.. " | set cmdheight="
			.. cmdheight
			.. " | set showtabline="
			.. showtabline
	)
	vim.cmd("startinsert")
end, { nargs = "*" })
