{ pkgs, ... }:
{
  vim = {
    visuals = {
      indent-blankline = {
        enable = true;
      };
    };
    ui = {
      noice = {
        enable = true;
        setupOpts = {
          lsp = {
            progress.enabled = false;
            signature.enabled = true;
          };
          presets = {
            lsp_doc_border = true;
            long_message_to_split = true;
            inc_rename = false;
            command_palette = false;
            bottom_search = true;
          };
        };
      };
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
