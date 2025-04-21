_: {
  # Use homebrew to install casks and Mac App Store apps
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      upgrade = true;
    };

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
