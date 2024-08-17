return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"julianolf/nvim-dap-lldb",
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local cfg = {
			configurations = {
				-- C lang configurations
				c = {
					{
						name = "Launch debugger",
						type = "lldb",
						request = "launch",
						cwd = "${workspaceFolder}",
						program = function()
							-- Build with debug symbols
							local out = vim.fn.system({ "make", "debug" })
							-- Check for errors
							if vim.v.shell_error ~= 0 then
								vim.notify(out, vim.log.levels.ERROR)
								return nil
							end
							-- Return path to the debuggable program
							return "sudo " .. vim.fn.expand("path/to/executable")
						end,
					},
				},
			},
		}

		require("dap-lldb").setup(cfg)
		require("dapui").setup()
		require("dap-go").setup()

		local dap, dapui = require("dap"), require("dapui")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<Leader>dt", ":DapToggleBreakpoint<CR>")
		vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
		vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
		vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>")
	end,
}
