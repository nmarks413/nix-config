_: {
  vim = {
    options = {
      linebreak = true;
    };
    git = {
      gitsigns.setupOpts = {
        current_line_blame = true;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "right_align";
          delay = 25;
          ignore_whitespace = true;
          virt_text_priority = 100;
          use_focus = true;
        };
      };
    };
    keymaps =
      let
        mkKeymap = mode: key: action: desc: {
          inherit mode;
          inherit key action desc;
        };
        n = mkKeymap "n"; # normal mode
      in
      [
        # UI
        (n "<leader>e" ":lua require('snacks').explorer()<CR>" "File Explorer")
        # Find Files
        (n "<leader><space>" ":lua require('snacks').picker.smart()<CR>" "Smart Find Files")
        (n "<leader>f" ":lua require('snacks').picker.grep()<CR>" "Grep Files")
      ];
  };
}
