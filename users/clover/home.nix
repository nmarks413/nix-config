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
          (ffmpeg.override {
            withSvtav1 = true;
          })
          ripgrep
          uv
          nh
          pkgs.autofmt
        ];
        # packages to install for desktop environments (non-server)
        desktop = [
          git-town
          lazygit
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
    # bat.enable = true;
    btop.enable = true;
    fd.enable = true;
    hyfetch.enable = true;
    # sort-lines:end

    ghostty = {
      enable = true;
      shader = "cursor-smear-black.glsl";
      package = null;
      settings = {
        theme = "light:catppuccin-latte,dark:catppuccin-macchiato";
        font-family = "AT Name Mono";
        adjust-cursor-thickness = 1;
        minimum-contrast = 1.1;
        background-opacity = 0.9;
        background-blur = true;
      };
    };

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
