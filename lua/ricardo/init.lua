local M = {}

local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local actions = require("telescope.actions")
local config = require("telescope.config").values
local previewers = require("telescope.previewers")

-- incoming_calls calls the CocAction to find all the incoming calls for a
-- given function. If it can't find any then prints an alert, if it can then
-- opens up a telescope picker with the results.
function M.incoming_calls()
    local incoming_calls = vim.fn.CocAction("incomingCalls")
    if not incoming_calls or vim.tbl_isempty(incoming_calls) then
        vim.notify("no incoming calls", vim.log.levels.WARN)
        return
    end

    pickers.new({}, {
        prompt_title = "Callers",
        finder = finders.new_table {
            results = incoming_calls,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.from.name .."()" .. entry.from.detail,
                    ordinal = entry.from.name,
                    filename = vim.uri_to_fname(entry.from.uri),
                    lnum = entry.from.range.start.line + 1,
                    col = entry.from.range.start.character + 1,
                    text = entry.from.name .. " - " .. entry.from.detail,
                }
            end,
        },
        sorter = config.generic_sorter({}),
        previewer = previewers.vim_buffer_vimgrep.new({}),
        attach_mappings = function(_, map)
            -- maps <C-q> to send the results to quickfix window in both
            -- interactive or normal mode. 'copen' is open to actually open the
            -- quickfix split.
            map('i', '<C-q>', function(prompt_bufnr)
                actions.send_to_qflist(prompt_bufnr)
                vim.cmd('copen')
            end)
            map('n', '<C-q>', function(prompt_bufnr)
                actions.send_to_qflist(prompt_bufnr)
                vim.cmd('copen')
            end)
            return true
        end,
    }):find()
end

return M
