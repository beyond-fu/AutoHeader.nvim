local config = require "AutoHeader.config"
local main = require "AutoHeader.main"

local M = {}

function M.setup(opts)
  local custom = vim.api.nvim_create_augroup("custom_header_group", {})

  config.set(opts)
  vim.api.nvim_create_user_command("AutoHeader", main.stdheader, {})

  if config.opts.auto_update == true then
    vim.api.nvim_create_autocmd("BufWritePre", {
      nested = true,
      group = custom,
      callback = function()
        if main.has_header() then
          main.update_header()
        end
      end,
    })
  end

  if config.opts.default_map == true then
    vim.keymap.set("n", "<F4>", "<cmd>AutoHeader<CR>", { silent = true, noremap = true, desc = "Insert AutoHeader" })
  end
end

return M
