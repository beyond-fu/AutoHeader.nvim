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
        -- local header = main.gen_header()
        -- if main.has_header(header) then
        --   main.update_header(header)
        -- end
        if main.has_header() then
          main.update_header()
        end
      end,
    })
  end

  if config.opts.default_map == true then
    vim.keymap.set("n", "<F1>", ":AutoHeader<CR>", { silent = true, noremap = true })
  end
end

return M
