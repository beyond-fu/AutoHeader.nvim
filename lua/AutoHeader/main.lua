---@tag AutoHeader.header

---@brief [[
---
---This module manages the header.
---
---@brief ]]

local M = {}
local config = require "AutoHeader.config"
local git = require "AutoHeader.git"
local recognize_text = "This is a standard header."

---Get username.
---@return string|nil
function M.user()
  return vim.g.user or (config.opts.git.enabled and git.user()) or config.opts.user
end

---Get email.
---@return string|nil
function M.email()
  return vim.g.mail or (config.opts.git.enabled and git.email()) or config.opts.mail
end

---Get left and right comment symbols from the buffer.
---@return string, string
function M.comment_symbols()
  local str = vim.api.nvim_get_option_value("commentstring", {})

  if vim.tbl_contains({ "c", "cc", "cpp", "cxx", "tpp", "systemverilog", "verilog" }, vim.bo.filetype) then
    str = "/* %s */"
  end

  -- Checks the buffer has a valid commentstring.
  if str:find "%%s" then
    local left, right = str:match "(.*)%%s(.*)"

    if right == "" then
      right = left
    end

    return vim.trim(left), vim.trim(right)
  end

  return "#", "#" -- Default comment symbols.
end

---Generate a formatted text line for the header.
---@param text string: The text to include in the line.
---@return string: The formatted header line.
function M.gen_line(text)
  local max_length = config.opts.length - config.opts.margin * 2

  text = (text):sub(1, max_length)

  local left, right = M.comment_symbols()
  local left_margin = (" "):rep(config.opts.margin - #left)
  local right_margin = (" "):rep(config.opts.margin - #right)
  local spaces = (" "):rep(max_length - #text)

  return left .. left_margin .. text .. spaces .. right_margin .. right
end

---Generate a complete header.
---@return table: A table ontaining all lines of header.
function M.gen_header()
  local left, right = M.comment_symbols()
  local fill_line = left .. " " .. string.rep("*", config.opts.length - #left - #right - 2) .. " " .. right
  local empty_line = M.gen_line ""
  local date = os.date "%Y/%m/%d %H:%M:%S"

  local header = {
    fill_line,
    empty_line,
    M.gen_line(recognize_text),
  }
  if config.opts.copyright then
    table.insert(
      header,
      M.gen_line(
        "Copyright (C) " .. os.date "%Y" .. " " .. (config.opts.company or M.user()) .. ". All rights reserved."
      )
    )
  end
  table.insert(header, M.gen_line "")
  table.insert(header, M.gen_line("File name: " .. vim.fn.expand "%:t"))
  table.insert(header, M.gen_line("Author: " .. M.user() .. " <" .. M.email() .. ">"))
  table.insert(header, M.gen_line "")
  table.insert(header, M.gen_line("Created time: " .. date .. " by " .. M.user()))
  table.insert(header, M.gen_line("Updated time: " .. date .. " by " .. M.user()))
  if config.opts.description then
    table.insert(header, M.gen_line "")
    table.insert(header, M.gen_line "Description: ")
  end
  if config.opts.license then
    table.insert(header, M.gen_line "")
    table.insert(header, M.gen_line("License: " .. config.opts.license_type))
  end
  table.insert(header, empty_line)
  table.insert(header, fill_line)

  return header
end

---Checks if there is a valid header in the current buffer.
---@return boolean: `true` if the header exists, `false` otherwise.
function M.has_header()
  local line = vim.api.nvim_buf_get_lines(0, 2, 3, false)

  if string.find(line[1], recognize_text) then
    return true
  else
    return false
  end
end

---Insert a header into the current buffer.
function M.insert_header()
  if not vim.api.nvim_get_option_value("modifiable", {}) then
    vim.notify("The current buffer cannot be modified.", vim.log.levels.WARN, { title = "AutoHeader" })
    return
  end

  local header = M.gen_header()
  -- If the first line is not empty, the blank line will be added after the header.
  if vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] ~= "" then
    table.insert(header, "")
  end

  vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
end

---Update an existing header in the current buffer.
---@param header table: Header to override the current one.
function M.update_header()
  local update_line = config.opts.copyright and 10 or 9
  local date = os.date "%Y/%m/%d %H:%M:%S"
  local gen_update_line = M.gen_line("Updated time: " .. date .. " by " .. M.user())

  vim.api.nvim_buf_set_lines(0, update_line - 1, update_line, false, { gen_update_line })
end

---Inserts or updates the header in the current buffer.
function M.stdheader()
  if not M.has_header() then
    M.insert_header()
  else
    M.update_header()
  end
end

return M
