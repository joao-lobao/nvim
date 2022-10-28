-- custom_fname solution for changing color when buffer is modified
-- reference in https://github.com/nvim-lualine/lualine.nvim/issues/335#issuecomment-916759033
local custom_fname = require('lualine.components.filename'):extend()
local highlight = require'lualine.highlight'
local default_status_colors = { saved = '#82aaff', modified = '#c3e88d' }

function custom_fname:init(options)
  custom_fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group({bg = default_status_colors.saved}, 'filename_status_saved', self.options),
    modified = highlight.create_component_highlight_group({bg = default_status_colors.modified}, 'filename_status_modified', self.options),
  }
  if self.options.color == nil then self.options.color = '' end
end

function custom_fname:update_status()
  local data = custom_fname.super.update_status(self)
  local show_text = ''
  if vim.bo.modified and self.status_colors.modified then show_text = '●' end
  data = highlight.component_format_highlight(vim.bo.modified
  and self.status_colors.modified
  or self.status_colors.saved) .. show_text
  return data
end

require'lualine'.setup {
  options = {
    -- theme = "gruvbox",
    theme = "material",
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        show_filename_only = false,  -- Shows shortened relative path when set to false.
        show_modified_status = true, -- Shows indicator when the buffer is modified.
      }
    },
    lualine_z = { custom_fname }
  }
}
