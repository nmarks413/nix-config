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
      (mkKeymap "n" "<leader>e" "<cmd>lua require('snacks').explorer()<cr>" "File Explorer")

      # Snacks Picker Replaces Telescope!?
      (mkKeymap "n" "<leader><space>" "<cmd>lua require('snacks').picker.smart()" "Smart Find Files")
      (mkKeymap "n" "<leader>ff" "<cmd>lua require('snacks').picker.files()<cr>" "Find File")
      # (mkKeymap "n" "<leader>fr" "<cmd>lua require('snacks').picker.recent()<cr>" "Open Recent File")
      (mkKeymap "n" "<leader>fg" "<cmd>lua require('snacks').picker.grep()<cr>" "Grep Files")
      # (mkKeymap "n" "<leader>fb" "<cmd>lua require('snacks').picker.buffers()<cr>" "Grep Buffers")
      # (mkKeymap "n" "<leader>fh" "<cmd>lua require('snacks').picker.help()<cr>" "Grep Help Tags")
      # (mkKeymap "n" "<leader>fg" "<cmd>lua require('snacks').picker.git_files()<cr>" "Grep Git Files")
      # (mkKeymap "n" "<leader>fd" "<cmd>lua require('snacks').picker.diagnostics()<cr>" "Grep Diagnostics")
      # (mkKeymap "n" "<leader>fc" "<cmd>lua require('aerial').snacks_picker()<cr>" "Code Outline")

      # Lsp
      (mkKeymap "n" "gd" "<cmd>lua require('snacks').picker.lsp_definitions<cr>" "Goto Definition")
      (mkKeymap "n" "gD" "<cmd>lua require('snacks').picker.lsp_declarations<cr>" "Goto Declarations")
      (mkKeymap "n" "gI" "<cmd>lua require('snacks').picker.lsp_implementations<cr>" "Goto Implementation")
      (mkKeymap "n" "gr" "<cmd>lua require('snacks').picker.lsp_references<cr>" "Goto References")
      (mkKeymap "n" "gy" "<cmd>lua require('snacks').picker.lsp_type_definitions<cr>" "Goto T[y]pe Definition")
    ];
  };
}
