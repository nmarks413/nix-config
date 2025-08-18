{ lib, pkgs, ... }:
{
  vim.formatter.conform-nvim = {
    enable = true;
    setupOpts = {
      formatters_by_ft =
        let
          autofmt = lib.mkLuaInline ''{"autofmt",stop_after_first=true}'';
        in
        {
          css = autofmt;
          html = autofmt;
          javascript = autofmt;
          javascriptreact = autofmt;
          json = autofmt;
          jsonc = autofmt;
          markdown = autofmt;
          nix = autofmt;
          rust = autofmt;
          typescript = autofmt;
          typescriptreact = autofmt;
          yaml = autofmt;
        };
      formatters.autofmt = {
        "inherit" = false;
        args = [
          "--stdio"
          "$FILENAME"
        ];
        command = "${pkgs.autofmt}/bin/autofmt";
      };
    };
  };
}
