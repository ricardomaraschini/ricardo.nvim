vim.keymap.set("n", "<C-c>", function()
    require("ricardo").incoming_calls()
end)

vim.keymap.set("n", "<C-a>", function()
    vim.cmd("AvanteAsk")
end)
