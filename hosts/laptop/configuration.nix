{ config, pkgs, … }:

{
  environment.systemPackages =
    [
      pkgs.home-manager
    ];

  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/src/github.com/evantravers/dotfiles/nix-darwin-configuration";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [ "nix-command" "flakes" ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;  # default shell on catalina
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Install fonts
  fonts.fontDir.enable = true;
  fonts.fonts = [
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
      autohide = true;
      orientation = "left";
      show-process-indicators = false;
      show-recents = false;
      static-only = true;
    };
    # a finder that tells me what I want to know and lets me work
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    # Tab between form controls and F-row that behaves as F1-F12
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      "com.apple.keyboard.fnState" = true;
    };
  };
}
