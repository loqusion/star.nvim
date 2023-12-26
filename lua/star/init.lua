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

---Return the value `fn` yanks into a register, after restoring the register
---@param reg string Register to yank into
---@param fn function A function which sets register `reg` as its side effect
local function yank_with_reg(reg, fn)
  local saved_reg = vim.fn.getreg(reg)
  fn(reg)
  local ret = vim.fn.getreg(reg)
  vim.fn.setreg(reg, saved_reg)
  return ret
end

---WARNING: This function has the side effect of moving the cursor position to the beginning of the selected word,
---which is intended.
---
---@param is_visual boolean
local function get_word(is_visual)
  local cmd = is_visual and "y" or "yiw"

  -- https://github.com/nvim-telescope/telescope.nvim/blob/f336f8cfab38a82f9f00df380d28f0c2a572f862/lua/telescope/builtin/__files.lua#L196-L199
  return yank_with_reg("v", function(reg)
    vim.cmd(([[noautocmd sil norm! "%s%s]]):format(reg, cmd))
  end)
end

---@param action star.Action
---@param is_visual? boolean
function M.star(action, is_visual)
  is_visual = vim.F.if_nil(is_visual, vim.fn.mode() == "v")

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
    M.star(action, is_visual)
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
