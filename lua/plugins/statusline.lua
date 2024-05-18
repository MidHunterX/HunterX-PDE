-- ------------------------------------------------------------------------ --
--                             CUSTOM FUNCTIONS                             --
-- ------------------------------------------------------------------------ --

-- Buffer Attached LSP Server
local function lsp_name()
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return ''
  end
  return '☰' -- 'LSP: '..clients[1].name
end

-- Recording Status
local function recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end -- not recording
  return "󰑊 REC " .. reg
end

-- 'o:encoding': Don't display if encoding is UTF-8.
local encoding = function()
  local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
  return ret
end

-- 'fileformat': Don't display if &ff is unix.
local fileformat = function()
  local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
  local icons = {
    dos = '',  -- e70f
    mac = '',  -- e711
    unix = ''  -- e712
  }
  return icons[ret] or ret
end

-- ------------------------------------------------------------------------- --
--                               RETURN CONFIG                               --
-- ------------------------------------------------------------------------- --

return {
  'nvim-lualine/lualine.nvim',
  -- For preventing loading of lualine on dashboard
  -- Enabling any events makes bufferline disappear after opening a file from dashboard via fuzzy finding (+8ms)
  -- event = { "BufAdd", "BufNewFile", "BufRead" },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {

    options = {
      icons_enabled = true,
      component_separators = '',
      section_separators = '',
    },

    -- +-------------------------------------------------------------------+ --
    -- |  A  |  B  |  C                                     X  |  Y  |  Z  | --
    -- +-------------------------------------------------------------------+ --

    sections = {

      lualine_a = {
        {
          'mode',
          separator = { left = '', right = '' },
          -- fmt = function(str) return str:sub(1,3) end,
          padding = { left = 1, right = 1 }
        },
      },
      lualine_b = {
        { 'branch', separator = { right = '' }, draw_empty = true, },
      },
      lualine_c = {
        'filename',
        { 'diff', symbols = {added = ' ', modified = ' ', removed = ' '} },
        '%=',
        'diagnostics',
      },

      lualine_x = {
        fileformat,
        encoding,
        'filetype',
      },
      lualine_y = {
        { 'progress', separator = { left = '' }},
      },
      lualine_z = {
        { 'location', separator = { left = '', right = '' }},
      },

    },

    -- +-------------------------------------------------------------------+ --
    -- |  A  |  B  |  C                                     X  |  Y  |  Z  | --
    -- +-------------------------------------------------------------------+ --

    tabline = {

      lualine_a = {
        {'searchcount', separator = { left = '', right = '' }},
        {
          recording,
          separator = { left = '', right = '' },
          color = { fg = "#ffffff", bg = "#ff2b00" }
        }
      },
      lualine_b = {
      },
      lualine_c = {'selectioncount'},
      lualine_x = {},
      lualine_y = {
        { lsp_name, separator = { left = '' }, draw_empty = true },
      },
      lualine_z = {
        -- Returns initial 4 characters of filename because:
        -- I only need a simple visual id for quickly recognizing buffers.
        -- Prevents overflow on long filenames
        {
          'buffers',
          fmt = function(str) return str:sub(1,4) end,
          use_mode_colors = true,
          symbols = {
            modified = ' ●',
            directory =  '',
            alternate_file = '',
          },
          -- Source: Nerdfont ple-.*
          separator = { left = '', right = '' },
          component_separators = { right = '' },
          section_separators = { left = '', right = '' },
        },
      }

    },

  },

}
