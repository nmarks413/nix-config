{
  inputs,
  pkgs,
  lib,
  host,
  ...
}: let
  hostServer = false;
in {
  home = {
    stateVersion = "23.05"; # Please read the comment before changing.
    packages = with pkgs; let
      # packages to always install
      all = [
        ffmpeg
        ripgrep
      ];
      # packages to install for desktop environments (non-server)
      desktop = [
      ];
      # packages to install on all servers
      server = [];
      # packages to install on macOS desktops
      darwin = [
        raycast
      ];
      # packages to install on linux desktops
      linux = [
        reaper # TODO: why does this break on macOS
      ];
    in
      all
      ++ (
        if host.darwin
        then darwin
        else linux
      )
      ++ (
        if hostServer
        then server
        else desktop
      );
  };
  programs = {
    # sort-lines:start
    bat.enable = true;
    btop.enable = true;
    fd.enable = true;
    hyfetch.enable = true;
    zsh.enable = true;
    # sort-lines:end

    # use a git-specific email
    git.userEmail = "git@paperclover.net";

    ssh = {
      enable = true;
      matchBlocks = rec {
        zenith = {
          user = "clo";
          port = 222;
        };
        "nas.paperclover.net" = lib.mkIf zenith;
      };
    };
  };
}
