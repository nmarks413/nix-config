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
    autocomplete.blink-cmp = {
      enable = true;
      mappings = {
        close = null;
        complete = null;
        confirm = null;
        next = null;
        previous = null;
        scrollDocsDown = null;
        scrollDocsUp = null;
      };

      setupOpts = {
        keymap = {
          preset = "super-tab";
        };
        completion = {
          ghost_text.enabled = false;
          list.selection.preselect = true;
          trigger = {
            show_in_snippet = true;
          };
          accept.auto_brackets.enabled = true;
        };
        signature = {
          enabled = true;
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
