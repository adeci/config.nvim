return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == '..' or name == '.git'
        end,
      },
      keymaps = {
        ['<c-c>'] = false,
        ['q'] = 'actions.close',
      },
      -- Open parent directory in current window
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' }),
      vim.keymap.set('n', '<leader>-', require('oil').toggle_float, { desc = 'Oil File Explorer' }),
    }
  end,
}
