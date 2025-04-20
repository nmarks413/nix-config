{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  # Use homebrew to install casks and Mac App Store apps
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      upgrade = true;
    };

    # taps = [
    #   "legcord/legcord"
    # ];

    brews = [
      "imagemagick"
      "opam"
    ];

    casks = [
      "battle-net"
      "stremio"
      "alt-tab"
      "legcord"
      "zulip"
      "zen-browser"
    ];

    masApps = {
      "wireguard" = 1451685025;
    };
  };
}
