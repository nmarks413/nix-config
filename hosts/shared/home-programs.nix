{
  pkgs,
  userSettings,
  ...
}: {
  nix-index.enable = true;
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
  };

  hyfetch = {
    enable = true;
    settings = {
      backend = "fastfetch";
      preset = userSettings.sexuality;
      mode = "rgb";
      light_dark = "dark";
      lightness = {
      };
      color_align = {
        mode = "horizontal";
      };
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
      test -r '/Users/${userSettings.username}/.opam/opam-init/init.fish' && source '/Users/${userSettings.username}/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
      batman --export-env | source
    '';
  };
  home-manager.enable = true;
}
