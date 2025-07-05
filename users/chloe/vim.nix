_: {
  vim = {
    languages.astro.enable = true;
    options = {
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      undofile = true;
      swapfile = false;
      showmode = false;
      foldlevel = 99;
      foldcolumn = "1";
      foldlevelstart = 99;
      foldenable = true;
      linebreak = true;
    };
    binds = {
      hardtime-nvim.setupOpts = {
        restriction_mode = "block";
        disable_mouse = false;
      };
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
        # Lsp
        (n "K" ":Lspsaga hover_doc<CR>" "Hover docs")
        (n "lr" ":lua vim.lsp.buf.rename()<CR>" "Rename")
        (n "gd" ":lua vim.lsp.buf.definition()<CR>" "Go to Definition")
        (n "gD" ":lua vim.lsp.buf.declaration()<CR>" "Go to Declaration")
      ];
  };
}
