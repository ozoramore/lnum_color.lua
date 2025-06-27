# lnum_color.lua

![ss](ss.png)

## usage

```lua
-- lazy.nvim
{
    'ozoramore/lnum_color.lua'
}

-- others
require('lnum_color').setup()
```

## customize

```lua
local function lnumfunc(lnum, current_cursor_line)
    local range = math.abs(lnum - current_cursor_line)
    if range == 1 then return 'LineNrGroup1' end
    if range == 2 then return 'LineNrGroup2' end
    if range == 3 then return 'LineNrGroup3' end
    if range % 10 == 0 then return 'LineNrGroup4' end
    return nil
end

-- lazy.nvim
{
    'ozoramore/lnum_color.lua',
    opts = {
        interval = 5, --  line number highlight interval( default 10, 0 is disable )
        get_name = lnumfunc -- customize function( default nil, nil is disable )
    }
}

-- others
require('lnum_color').setup({ interval = 5, get_name = lnumfunc })
```
