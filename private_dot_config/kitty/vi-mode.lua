-- local api = vim.api
-- local orig_buf = api.nvim_get_current_buf()
-- local term_buf = api.nvim_create_buf(false, true)
-- vim.wo.number = false
-- vim.wo.relativenumber = false
-- vim.wo.statuscolumn = ""
-- vim.wo.signcolumn = "no"
-- local lines = vim.api.nvim_buf_get_lines(orig_buf, 0, -1, false)
-- while #lines > 0 and vim.trim(lines[#lines]) == "" do
--   lines[#lines] = nil
-- end
-- local buf = vim.api.nvim_create_buf(false, true)
-- local channel = vim.api.nvim_open_term(buf, {})
-- vim.api.nvim_chan_send(channel, table.concat(lines, "\r\n"))
-- vim.api.nvim_set_current_buf(buf)
-- vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
-- vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
-- vim.defer_fn(function()
--   -- go to the end of the terminal buffer
--   vim.cmd.startinsert()
-- end, 10)
--
-- api.nvim_set_current_buf(term_buf)
-- vim.bo.scrollback = 100000
-- local term_chan = api.nvim_open_term(0, {})
-- api.nvim_chan_send(term_chan, table.concat(api.nvim_buf_get_lines(orig_buf, 0, -1, true), "\r\n"))
-- vim.fn.chanclose(term_chan)
-- api.nvim_buf_set_lines(orig_buf, 0, -1, true, api.nvim_buf_get_lines(term_buf, 0, -1, true))
-- api.nvim_set_current_buf(orig_buf)
-- api.nvim_buf_delete(term_buf, { force = true })
-- vim.bo.modified = false
-- api.nvim_win_set_cursor(0, { api.nvim_buf_line_count(0), 0 })

return function(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
	print("kitty sent:", INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
	vim.opt.encoding = "utf-8"
	vim.opt.clipboard = "unnamed"
	vim.opt.compatible = false
	vim.opt.number = false
	vim.opt.relativenumber = false
	vim.opt.termguicolors = true
	vim.opt.showmode = false
	vim.opt.ruler = false
	vim.opt.laststatus = 0
	vim.o.cmdheight = 0
	vim.opt.showcmd = false
	vim.opt.scrollback = INPUT_LINE_NUMBER + CURSOR_LINE
	local term_buf = vim.api.nvim_create_buf(true, false)
	local term_io = vim.api.nvim_open_term(term_buf, {})
	vim.api.nvim_buf_set_keymap(term_buf, "n", "q", "<Cmd>q<CR>", {})
	vim.api.nvim_buf_set_keymap(term_buf, "n", "<ESC>", "<Cmd>q<CR>", {})
	local group = vim.api.nvim_create_augroup("kitty+page", {})

	local setCursor = function()
		vim.api.nvim_feedkeys(tostring(INPUT_LINE_NUMBER) .. [[ggzt]], "n", true)
		local line = vim.api.nvim_buf_line_count(term_buf)
		if CURSOR_LINE <= line then
			line = CURSOR_LINE
		end
		vim.api.nvim_feedkeys(tostring(line - 1) .. [[j]], "n", true)
		vim.api.nvim_feedkeys([[0]], "n", true)
		vim.api.nvim_feedkeys(tostring(CURSOR_COLUMN - 1) .. [[l]], "n", true)
	end

	vim.api.nvim_create_autocmd("ModeChanged", {
		group = group,
		buffer = term_buf,
		callback = function()
			local mode = vim.fn.mode()
			if mode == "t" then
				vim.cmd.stopinsert()
				vim.schedule(setCursor)
			end
		end,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		pattern = "*",
		once = true,
		callback = function(ev)
			local current_win = vim.fn.win_getid()
			for _, line in ipairs(vim.api.nvim_buf_get_lines(ev.buf, 0, -2, false)) do
				vim.api.nvim_chan_send(term_io, line)
				vim.api.nvim_chan_send(term_io, "\r\n")
			end
			for _, line in ipairs(vim.api.nvim_buf_get_lines(ev.buf, -2, -1, false)) do
				vim.api.nvim_chan_send(term_io, line)
			end
			vim.api.nvim_win_set_buf(current_win, term_buf)
			vim.api.nvim_buf_delete(ev.buf, { force = true })
			vim.schedule(setCursor)
		end,
	})
end
