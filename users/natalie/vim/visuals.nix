{ pkgs, ... }:
{
  vim = {
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

  };
}
