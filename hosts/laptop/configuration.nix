{
  config,
  pkgs,
  ...
}: {
  # nixpkgs.overlays = [
  #   (final: prev: {nh-darwin = nh_darwin.packages.${prev.system}.default;})
  # ];
  environment.shellAliases.nh = "nh_darwin";

  # programs.nh = {
  #   enable = true;
  #   clean.enable = true;
  #   clean.extraArgs = "--keep-since 4d --keep 3";
  #   flake = "/Users/nmarks/.dotfiles";
  # };

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

  programs.zsh = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Install fonts
  fonts.packages = [
    pkgs.iosevka
  ];

  services.tailscale.enable = true;

  # Use homebrew to install casks and Mac App Store apps
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };

    taps = [
      "armcord/armcord"
    ];

    casks = [
      "1password"
      "firefox"
      "obsidian"
      "raycast"
      "armcord"
      "battle-net"
    ];

    masApps = {
      "wireguard" = 1451685025;
    };
  };

  # set some OSX preferences that I always end up hunting down and changing.
  system.defaults = {
    # minimal dock
    dock = {
      autohide = false;
      show-process-indicators = true;
      show-recents = true;
      static-only = true;
    };
    # a finder that tells me what I want to know and lets me work
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };

    CustomUserPreferences = {
      launchd.user.agents.UserKeyMapping.serviceConfig = {
        ProgramArguments = [
          "/usr/bin/hidutil"
          "property"
          "--match"
          "{&quot;ProductID&quot;:0x0,&quot;VendorID&quot;:0x0,&quot;Product&quot;:&quot;Apple Internal Keyboard / Trackpad&quot;}"
          "--set"
          (
            let
              # https://developer.apple.com/library/archive/technotes/tn2450/_index.html
              caps_lock = "0x700000039";
              escape = "0x700000029";
            in "{&quot;UserKeyMapping&quot;:[{&quot;HIDKeyboardModifierMappingDst&quot;:${escape},&quot;HIDKeyboardModifierMappingSrc&quot;:${caps_lock}},{&quot;HIDKeyboardModifierMappingDst&quot;:${caps_lock},&quot;HIDKeyboardModifierMappingSrc&quot;:${escape}}]}"
          )
        ];
        RunAtLoad = true;
      };
    };
  };
}
