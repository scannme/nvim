return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- DAP UI 自动开关
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]   = function() dapui.close() end

      -- Java: attach 到远程 JVM（比如 iris 开着 5005 debug 端口）
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Attach to iris (localhost:5005)",
          hostName = "127.0.0.1",
          port = 5005,
        },
        {
          type = "java",
          request = "attach",
          name = "Attach to remote (custom host:port)",
          hostName = function()
            return vim.fn.input("Host: ", "127.0.0.1")
          end,
          port = function()
            return tonumber(vim.fn.input("Port: ", "5005"))
          end,
        },
      }

      -- 通用 DAP 快捷键
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end
      map("<F5>",         dap.continue,           "DAP: Continue / Start")
      map("<F10>",        dap.step_over,          "DAP: Step Over")
      map("<F11>",        dap.step_into,          "DAP: Step Into")
      map("<F12>",        dap.step_out,           "DAP: Step Out")
      map("<leader>db",   dap.toggle_breakpoint,  "DAP: Toggle Breakpoint")
      map("<leader>dB",   function() dap.set_breakpoint(vim.fn.input("Condition: ")) end,
                                                  "DAP: Conditional Breakpoint")
      map("<leader>dr",   dap.repl.open,          "DAP: Open REPL")
      map("<leader>dt",   dap.terminate,          "DAP: Terminate")
      map("<leader>du",   dapui.toggle,           "DAP: Toggle UI")
    end,
  },
}
