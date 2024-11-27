<h1 align="center">
  ⭐ star.nvim
</h1>

A simple plugin that makes star mappings (`*`, `g*`) behave more sensibly.

- Cursor stays on current word instead of jumping to next search item; use `n`/`N` to navigate
- `#` and `g#` are the same as `*` and `g*` by default
- Any mappings can be customized or disabled
- Search is case sensitive

## Installation

<details>
  <summary>lazy.nvim</summary>

```lua
{
  "loqusion/star.nvim",
  keys = {
    { "*", mode = { "n", "x" } },
    { "g*", mode = { "n", "x" } },
    { "#", mode = { "n", "x" } },
    { "g#", mode = { "n", "x" } },
  },
  opts = {},
}
```

<aside>
  <code>lazy.nvim</code>'s <code>keys</code> doesn't affect how <code>star.nvim</code> assigns mappings; it only affects
  lazy-loading. To configure the keys, use the <code>opts.keys</code> field (or set <code>opts.auto_map</code> to
  <code>false</code> and <a href="#manual-keymaps">do mappings yourself</a>).
</aside>

</details>

<details>
  <summary>Packer</summary>

```lua
require("packer").startup(function()
  use({
    "loqusion/star.nvim",
    config = function()
      require("star").setup()
    end,
  })
end)
```

</details>

## Options

```lua
require("star").setup({
  -- Keys to remap
  -- Set a key to false to disable
  keys = {
    ["*"] = "star",
    ["g*"] = "gstar",
    ["#"] = "star",
    ["g#"] = "gstar",
  },
  -- Set this to false if you want to do mapping yourself
  auto_map = true,
})
```

## Manual Keymaps

If you want to set the keymaps yourself, you can do something like:

```lua
require("star").setup({
  auto_map = false,
})

vim.keymap.set({ "n", "x" }, "*", function()
  require("star").star("star")
end)
vim.keymap.set({ "n", "x" }, "g*", function()
  require("star").star("gstar")
end)

-- or with lazy.nvim:
{
  "loqusion/star.nvim",
  keys = {
    { "*", function() require("star").star("star") end },
    { "g*", function() require("star").star("gstar") end },
  },
  opts = {
    auto_map = false,
  },
}
```

## Credits

- [vim-star](https://github.com/linjiX/vim-star)
