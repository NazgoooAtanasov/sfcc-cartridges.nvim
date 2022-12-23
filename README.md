# sfcc-cartridges.nvim
Ah, yes. Finally.

## Why?
Because nothing else feels more painful than to write the long require strings.

## Dependencies?
Yes:
1. `find`;
2. [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).

## How to?
Just install it with your plugin manager and put that lua code somewhere in your config
```lua
require('sfcc-cartridges').setup({
    sourceName: 'sfcc' -- this `sourceName` needs to be the same as what you put in the `sources` map
})
```

And the following line in the [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) list of sources.
```lua
sources = {
    -- other sources
    { name = "sfcc" }
    -- other sources
}
```

Tested only on linux 🤷
