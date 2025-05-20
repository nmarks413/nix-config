{ pkgs, host, ... }:
let
  hostServer = false;
in
{
  home = {
    stateVersion = "23.05"; # Please read the comment before changing.
    packages =
      with pkgs;
      let
        # packages to always install
        all = [
          ffmpeg
          ripgrep
          uv
          nh
        ];
        # packages to install for desktop environments (non-server)
        desktop = [
        ];
        # packages to install on all servers
        server = [ ];
        # packages to install on macOS desktops
        darwin = [
          raycast
        ];
        # packages to install on linux desktops
        linux = [
          reaper # TODO: why does this break on macOS
        ];
      in
      all ++ (if host.darwin then darwin else linux) ++ (if hostServer then server else desktop);
  };
  programs = {
    # sort-lines:start
    bat.enable = true;
    btop.enable = true;
    fd.enable = true;
    hyfetch.enable = true;
    # sort-lines:end

    # zsh is the shell i use
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history.size = 10000;

      shellAliases = {
        switch = "nh darwin switch ~/config";
      };
      profileExtra = ''
        function python() {
          dirname=$(dirname $1 2>/dev/null)
          if [ -z "$dirname" ]; then
            dirname=$(pwd)
          fi
          uv run --project "$dirname" "$@"
        }
      '';
    };

    # use a git-specific email
    git.userEmail = "git@paperclover.net";

    ssh = {
      enable = true;
      matchBlocks = rec {
        zenith = {
          user = "clo";
          port = 222;
        };
        "nas.paperclover.net" = zenith;
      };
    };
    neovide = {
      enable = !hostServer;
      settings = {
        font.normal = "AT Name Mono";
        font.size = 13;
      };
    };
  };
}
