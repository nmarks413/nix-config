{ pkgs, ... }:
{
  imports = [
    ./vim/default.nix
  ];

  vim = {
    #enable python provider
    withPython3 = true;
    python3Packages = [ "pynvim" ];

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
    startPlugins = [
      "nui-nvim"
    ];
    theme = {
      name = "catppuccin";
      style = "mocha";
    };
    hideSearchHighlight = true;
  };
}
