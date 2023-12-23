local M = {}

---@class (exact) star.Options
---@field keys table<star.Key, star.Action|false>
---@field auto_map boolean

---@alias star.Key "*"|"#"|"g*"|"g#"
---@alias star.Action "star"|"gstar"

---@type table<star.Key, star.Action|false>
M.keys = {
  ["*"] = "star",
  ["g*"] = "gstar",
  ["#"] = "star",
  ["g#"] = "gstar",
}

M.key_descriptions = {
  star = "Search for the word under the cursor",
  gstar = "Search for the word under the cursor (whole word)",
}

M.modes = { "n", "x" }
M.map_opts = { silent = true }

local function set_mode_normal()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

---@param fmt? string
local function star(fmt)
  fmt = fmt or "%s"
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", fmt:format(word))
  vim.opt.hlsearch = true
  vim.v.searchforward = true
  set_mode_normal()
end

---@param action star.Action
local function map_for(action)
  if action == "star" then
    return function()
      star()
    end
  elseif action == "gstar" then
    return function()
      star([[\<%s\>]])
    end
  end
end

local function do_maps()
  for key, action in pairs(M.keys) do
    if action then
      local map_opts = vim.tbl_extend("force", { desc = M.key_descriptions[action] }, M.map_opts)
      vim.keymap.set(M.modes, key, map_for(action), map_opts)
    end
  end
end

---@param opts star.Options?
function M.setup(opts)
  opts = opts or {}

  M.keys = vim.tbl_deep_extend("force", M.keys, opts.keys or {})

  if vim.F.if_nil(opts.auto_map, true) then
    do_maps()
  end
end

return M
