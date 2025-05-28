{ pkgs, ... }:
{
  vim = {
    visuals = {
      indent-blankline = {
        enable = true;
      };
    };
    ui = {
      borders = {
        enable = true;
      };
    };

    # Better help docs
    lazy.plugins."helpview.nvim" = {
      enabled = true;
      package = pkgs.vimPlugins.helpview-nvim;
      lazy = false;
    };
  };
}
