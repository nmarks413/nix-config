{ ... }:
let
  mkKeymap = mode: key: action: desc: {
    inherit mode;
    inherit key action desc;
  };
  n = mkKeymap "n"; # normal mode
in
{
  vim = {
    keymaps = [
      (n "<leader>e" ":lua require('snacks').explorer()<CR>" "File Explorer")
      # Snacks Picker Replaces Telescope!?
      (n "<leader><space>" ":lua require('snacks').picker.smart()<CR>" "Smart Find Files")
      (n "<leader>ff" ":lua require('snacks').picker.files()<CR>" "Find File")
      (n "<leader>fg" ":lua require('snacks').picker.grep()<CR>" "Grep Files")
    ];
  };
}
