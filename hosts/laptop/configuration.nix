{
  config,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/Users/nmarks/.dotfiles";
  };

  environment.systemPackages = [
    pkgs.home-manager
    pkgs.neovim
  ];

  # Use a custom configuration.nix location.
  #environment.darwinConfig = "$HOME/.dotfiles/hosts/laptop";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = ["nix-command" "flakes"];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true; # default shell on catalina
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Install fonts
  fonts.packages = [
    pkgs.iosevka
  ];

  # Use homebrew to install casks and Mac App Store apps
  homebrew = {
    enable = true;

    casks = [
      "1password"
      "firefox"
      "obsidian"
      "raycast"
    ];

    masApps = {
    };
  };

  # set some OSX preferences that I always end up hunting down and changing.
  system.defaults = {
    # minimal dock
    dock = {
      autohide = false;
      show-process-indicators = false;
      show-recents = true;
      static-only = true;
    };
    # a finder that tells me what I want to know and lets me work
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    # Tab between form controls and F-row that behaves as F1-F12
  };
}
