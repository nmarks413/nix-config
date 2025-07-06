{ ... }:
{
  vim.languages.astro.enable = true;
  vim.theme.extraConfig = ''
    if vim.g.neovide then
      vim.g.neovide_cursor_trail_size = 0.3
      vim.g.neovide_scroll_animation_length = 0.1;

      vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
      vim.keymap.set('v', '<D-c>', '"+y') -- Copy
      vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
      vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
      vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
      vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
    end
    vim.api.nvim_set_keymap("", '<D-v>', '+p<CR>', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  '';
}
