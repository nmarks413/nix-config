{
  config,
  pkgs,
  lib,
  ...
}: {
  atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    daemon.enable = true;
  };

  direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    extraConfig = "font_family Iosevka NF
                   italic_font auto
                   bold_italic_font  auto
                   bold_font  auto";
  };

  hyfetch = {
    enable = true;
    settings = {
      backend = "fastfetch";
      preset = "bisexual";
      mode = "rgb";
      light_dark = "dark";
      lightness = {
      };
      color_align = {
        mode = "horizontal";
        # custom_colors = [];
        # fore_back = null;
      };
      distro = null;
      pride_month_shown = [
      ];
      pride_month_disable = false;
    };
  };

  fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        inherit (pkgs.fishPlugins.tide) src;
      }
    ];
    shellAliases = {
      reboot-windows = "sudo efibootmgr --bootnext 0000; sudo reboot -h now";
    };
  };

  home-manager.enable = true;
}
