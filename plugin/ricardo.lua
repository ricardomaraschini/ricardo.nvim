vim.keymap.set("n", "<C-i>", function()
    require("ricardo").incoming_calls()
end)
