local colorscheme = "sonokai"

local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not status_ok then
  return
end



vim.cmd [[highlight NvimTreeEndOfBuffer guibg=none ctermbg=none ]]
vim.cmd [[highlight NvimTreeNormal guibg=none ctermbg=none ]]

vim.cmd [[highlight NormalFloat guibg=none ctermbg=none ]]
vim.cmd [[highlight FloatBorder guibg=none ctermbg=none ]]

-- local monokai = require("monokai-pro")
-- monokai.setup()
-- local status_ok, _ = pcall(vim.cmd.colorscheme, "monokai-pro")
-- if not status_ok then
--   return
-- end

--     custom_hlgroups = {
--         TSInclude = {
--             fg = palette.aqua,
--         },
--         GitSignsAdd = {
--             fg = palette.green,
--             bg = palette.base2
--         },
--         GitSignsDelete = {
--             fg = palette.pink,
--             bg = palette.base2
--         },
--         GitSignsChange = {
--             fg = palette.orange,
--             bg = palette.base2
--         },
--     }
-- }

