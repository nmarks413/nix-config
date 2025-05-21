_: {
  # Use homebrew to install casks and Mac App Store apps
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
    };

    brews = [
    ];

    casks = [
    ];

    masApps = {
      "wireguard" = 1451685025;
    };
  };
}
