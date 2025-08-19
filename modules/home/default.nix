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
}:
let
  cfg = config.programs;
in
{
  imports = mainHomeImports ++ [
    ./macos/sketchybar.nix
  ];
  options = {
    programs.ghostty.shader = lib.mkOption {
      type = lib.types.str;
      default = { };
      description = "set the ghostty shader, relative to 'files/ghostty'";
    };
    programs.android-sdk.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable android sdk stuff";
    };
  };
  config = {
    android-sdk = {
      enable = config.programs.android-sdk.enable;
      packages =
        sdk:
        with sdk;
        [
          build-tools-35-0-0
          cmdline-tools-latest
          emulator
          platform-tools
          platforms-android-35
          sources-android-35
          ndk-27-1-12297006
          cmake-3-22-1
        ]
        ++ lib.optionals host.darwin [
          system-images-android-35-google-apis-arm64-v8a
          system-images-android-35-google-apis-playstore-arm64-v8a
        ]
        ++ lib.optionals host.linux [
          system-images-android-35-google-apis-x86-64
          system-images-android-35-google-apis-playstore-x86-64
        ];
    };
    xdg = {
      enable = true;
    };
    home.shell = {
      enableShellIntegration = true;
    };
    programs = {
      home-manager.enable = true;
      nix-index.enable = true;

      direnv = {
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
        daemon.enable = cfg.atuin.enable;
      };

      bat = {
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
          batpipe
          prettybat
        ];
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
        shellAliases = {
        }
        // lib.optionalAttrs (!host.darwin) {
          reboot-windows = "sudo efibootmgr --bootnext 0000; sudo reboot -h now";
        };
        shellInit = ''
          batman --export-env | source
          test -r '/Users/${user.username}/.opam/opam-init/init.fish' && source '/Users/${user.username}/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
        '';
      };

      ghostty.settings.custom-shader = lib.mkIf (
        cfg.ghostty.shader != null
      ) "${../../files/ghostty}/${cfg.ghostty.shader}";
    };
  };
}
