{pkgs, ...}: {
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
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
    };

    autocmds = [
      {
        event = ["LspAttach"];
        pattern = ["*"];
        desc = "User: Set LSP folding if client supports it";
        callback = pkgs.lib.generators.mkLuaInline ''function(ctx) local client = assert(vim.lsp.get_client_by_id(ctx.data.client_id)) if client:supports_method("textDocument/foldingRange") then local win = vim.api.nvim_get_current_win() vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()" end end'';
      }
    ];
    theme = {
      name = "catppuccin";
      style = "mocha";
    };
    hideSearchHighlight = true;
  };
}
