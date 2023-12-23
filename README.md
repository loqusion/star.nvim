<h1 align="center">
  ✨ star.nvim
</h1>

A simple plugin that makes star mappings (`*`, `g*`) behave more sensibly.

- Cursor stays put instead of jumping to next search item
- `#` and `g#` are the same as `*` and `g*` by default
- Any mappings can be customized or disabled

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

</details>

<!-- prettier-ignore-start -->
> [!NOTE]
> `lazy.nvim`'s `keys` doesn't affect how `star.nvim` assigns mappings; it only affects lazy-loading.
> To configure the keys, use the `opts.keys` field.
<!-- prettier-ignore-end -->

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

## Credits

- [vim-star](https://github.com/linjiX/vim-star)
