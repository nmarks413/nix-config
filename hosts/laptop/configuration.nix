{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.home-manager
    pkgs.neovim
  ];

  nixpkgs.config.allowUnfree = true;

  # Use a custom configuration.nix location.
  #environment.darwinConfig = "$HOME/.dotfiles/hosts/laptop";

  # Auto upgrade nix package and the daemon service.
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = ["nix-command" "flakes"];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true; # default shell on catalina
  };

  programs.zsh = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps -p $PPID -o comm) != "fish" && -z ''${ZSH_EXUCTION_STRING} ]]
      then
        [[ -o login ]] && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Install fonts
  fonts.packages = [
    pkgs.iosevka
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.iosevka
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

    # taps = [
    #   "legcord/legcord"
    # ];

    brews = [
      "imagemagick"
    ];

    casks = [
      # "1password"
      # "firefox"
      # "obsidian"
      # "raycast"
      # "legcord"
      "battle-net"
      "stremio"
      "alt-tab"
      "legcord"
    ];

    masApps = {
      "wireguard" = 1451685025;
    };
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
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
