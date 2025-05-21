{...}: let
  mkKeymap = mode: key: action: desc: {
    inherit
      mode
      key
      action
      desc
      ;
  };
in {
  vim = {
    keymaps = [
      (mkKeymap "n" "<leader>e" ":lua require('snacks').explorer()<CR>" "File Explorer")

      # Snacks Picker Replaces Telescope!?
      (mkKeymap "n" "<leader><space>" ":lua require('snacks').picker.smart()<CR>" "Smart Find Files")
      (mkKeymap "n" "<leader>ff" ":lua require('snacks').picker.files()<CR>" "Find File")
      (mkKeymap "n" "<leader>fg" ":lua require('snacks').picker.grep()<CR>" "Grep Files")
      # Lsp
      (mkKeymap "n" "K" ":lua vim.lsp.buf.hover()<CR>" "Hover docs")
      (mkKeymap "n" "lr" ":lua vim.lsp.buf.rename()<CR>" "Rename")
      # (mkKeymap "n" "<leader>th" ":lua function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end<CR>" "Toggle Inlay Hints")
    ];
  };
}
