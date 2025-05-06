# This contains default configurations for set of programs
# and configuration, but does not enable many things on it's own.
{
  pkgs,
  lib,
  config,
  user,
  host,
  mainHomeImports,
  ...
}: let
  cfg = config.programs;
in {
  imports = mainHomeImports;
  programs = {
    home-manager.enable = true;
    nix-index.enable = true;

    direnv = {
      enableZshIntegration = true;
      nix-direnv.enable = config.programs.direnv.enable;
    };

    git = {
      enable = true;
      userName = lib.mkDefault user.name;
      userEmail = lib.mkDefault user.email;
      ignores = [
        (lib.mkIf host.darwin ".DS_Store") # When using Finder
        (lib.mkIf host.darwin "._*") # When using non-APFS drives
        # ViM and Neovim
        ".*.swp"
        ".nvimlog"
      ];
    };

    atuin = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      daemon.enable = cfg.atuin.enable;
    };
    bat = {
      extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch batpipe prettybat];
    };
    hyfetch = {
      settings = {
        backend = "fastfetch";
        preset = user.sexuality;
        mode = "rgb";
        light_dark = "dark";
        lightness = {
        };
        color_align = {
          mode = "horizontal";
        };
      };
    };
    fastfetch.enable = cfg.hyfetch.enable;

    fish = {
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
      shellAliases =
        { } // lib.optionalAttrs (!host.darwin) {
          reboot-windows = "sudo efibootmgr --bootnext 0000; sudo reboot -h now";
        };
      shellInit = ''
        batman --export-env | source
      '';
      ##test -r '/Users/${user.username}/.opam/opam-init/init.fish' && source '/Users/${user.username}/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
    };
  };
}
