return {
  'chrishrb/gx.nvim',
  keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
  cmd = { 'Browse' },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  dependencies = { 'nvim-lua/plenary.nvim' },
  submodules = false,

  config = function()
    require('gx').setup {
      open_browser_app = 'wslview',
      open_browser_args = {},
      handlers = {
        plugin = true,
        github = true,
        package_json = true,
        search = true,
        go = true,
        rust = {
          name = 'rust',
          filetype = { 'toml' },
          filename = 'Cargo.toml',
          handle = function(mode, line, _)
            local crate = require('gx.helper').find(line, mode, '(%w+)%s-=%s')

            if crate then
              return 'https://crates.io/crates/' .. crate
            end
          end,
        },
      },
    }
  end,
}
