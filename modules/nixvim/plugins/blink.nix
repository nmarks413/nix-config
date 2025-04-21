{
  lib,
  pkgs,
  ...
}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      gh
      wordnet
      glab
    ];

    extraPlugins = [
    ];

    plugins = {
      blink-cmp = {
        enable = true;

        lazyLoad.settings.event = [
          "InsertEnter"
          "CmdlineEnter"
        ];

        settings = {
          keymap.preset = "super-tab";
          completion = {
            ghost_test.enabled = true;

            documentation = {
              auto_show = true;

              window.border = "rounded";
            };
          };
        };
      };
    };
  };
}
