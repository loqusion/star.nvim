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
  gstar = "Search for the word under the cursor",
}

M.modes = { "n", "x" }
M.map_opts = { silent = true }

local function set_mode_normal()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

---WARNING: This function assumes you are currently in visual mode.
---After executing, you will return to normal mode.
local function get_visual_word()
  -- https://github.com/nvim-telescope/telescope.nvim/blob/f336f8cfab38a82f9f00df380d28f0c2a572f862/lua/telescope/builtin/__files.lua#L196-L199
  local saved_reg = vim.fn.getreg("v")
  vim.cmd([[noautocmd sil norm "vy]])
  local sele = vim.fn.getreg("v")
  vim.fn.setreg("v", saved_reg)
  return sele
end

---@param is_visual boolean
local function get_word(is_visual)
  if is_visual then
    return get_visual_word()
  end

  return vim.fn.expand("<cword>")
end

---@param action star.Action
---@param is_visual boolean
local function star(action, is_visual)
  local fmt
  if is_visual or action == "gstar" then
    fmt = "%s"
  elseif action == "star" then
    fmt = [[\<%s\>]]
  else
    vim.notify(("Unknown action: `%s`"):format(action), vim.log.levels.ERROR)
    return
  end

  local word = get_word(is_visual)
  local item = fmt:format(word)

  set_mode_normal()

  vim.fn.setreg("/", item)
  vim.fn.histadd("/", item)
  vim.opt.hlsearch = true
  vim.v.searchforward = true
end

---@param action star.Action
---@param is_visual boolean
local function map_for(action, is_visual)
  return function()
    star(action, is_visual)
  end
end

local function do_maps()
  for key, action in pairs(M.keys) do
    if action then
      local map_opts = vim.tbl_extend("force", { desc = M.key_descriptions[action] }, M.map_opts)
      vim.keymap.set("n", key, map_for(action, false), map_opts)
      vim.keymap.set("x", key, map_for(action, true), map_opts)
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
