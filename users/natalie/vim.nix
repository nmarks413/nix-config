{ pkgs, ... }:
{
  imports = [
    ./vim/default.nix
  ];
  vim = {
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
      foldmethod = "expr";
      #Default to treesitter folding
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
    };

    autocmds = [
      #Autocommand to fall back to treesitter folding if LSP doesnt support it
      {
        event = [ "LspAttach" ];
        callback = pkgs.lib.generators.mkLuaInline ''
          function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client:supports_method('textDocument/foldingRange') then
              local win = vim.api.nvim_get_current_win()
              vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
            end
          end
        '';
      }
    ];

    tabline = {
      nvimBufferline.enable = true;
    };
    # nvf versions is VERY outdated
    # pluginOverrides = {
    #   hardtime-nvim = pkgs.fetchFromGitHub {
    #     owner = "m4xshen";
    #     repo = "hardtime.nvim";
    #     rev = "v1.0.1";
    #     hash = "sha256-5tqiSuGvBJcr8l6anEBojXEaaxFS1P5T1ROr46ylVhk=";
    #   };
    # };
    startPlugins = [
      "nui-nvim"
    ];
    binds = {
      hardtime-nvim = {
        enable = true;
        setupOpts = {
          disable_mouse = false;
          restriction_mode = "warn";
        };
      };
    };

    theme = {
      name = "catppuccin";
      style = "mocha";
    };
    hideSearchHighlight = true;
  };
}
