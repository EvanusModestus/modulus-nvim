{
       'dnlhc/glance.nvim',
       config = function()
           require('glance').setup()
           vim.keymap.set('n', 'gD', '<CMD>Glance definitions<CR>')
           vim.keymap.set('n', 'gR', '<CMD>Glance references<CR>')
       end
   }
