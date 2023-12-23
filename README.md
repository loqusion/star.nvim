# star.nvim

## Installation

<details>
  <summary>lazy.nvim</summary>

```lua
{
  "loqusion/star.nvim",
  keys = { "*", "g*", "#", "g#" },
  opts = {},
}
```

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
