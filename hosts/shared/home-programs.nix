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

  bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch batpipe prettybat];
    config = {
      theme = "catpuccin";
    };
    themes = {
      catpuccin = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          hash = "sha256-6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
          rev = "699f60fc8ec434574ca7451b444b880430319941";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
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
      distro = "nixos";
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
      {
        name = "!!";
        inherit (pkgs.fishPlugins.bang-bang) src;
      }
    ];
    shellAliases = {
      reboot-windows = "sudo efibootmgr --bootnext 0000; sudo reboot -h now";
    };
    shellInit = ''
      test -r '/Users/nmarks/.opam/opam-init/init.fish' && source '/Users/nmarks/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
      batman --export-env | source
    '';
  };
  home-manager.enable = true;
}
