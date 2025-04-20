{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ../../modules/macos/icons.nix
    ../../modules/macos/homebrew.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
    pinentry_mac
  ];

  # environment.customIcons = {
  #   enable = true;
  #   icons = [
  #     {
  #       path = "/Applications/Zen.app";
  #       icon = "/Users/nmarks/.dotfiles/icons/Zen_icons/firefox.icns";
  #     }
  #   ];
  # };

  # Use a custom configuration.nix location.
  #environment.darwinConfig = "$HOME/.dotfiles/hosts/laptop";

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

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };

  # set some OSX preferences that I always end up hunting down and changing.
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;

        #Ew.
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSDisableAutomaticTermination = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        AppleICUForce24HourTime = true;
      };
      # minimal dock
      dock = {
        autohide = true;
        autohide-time-modifier = 0;
        show-process-indicators = true;

        expose-group-apps = true;

        show-recents = true;
        static-only = true;

        mineffect = "scale";

        orientation = "bottom";
      };
      # a finder that tells me what I want to know and lets me work
      finder = {
        _FXShowPosixPathInTitle = true;
        FXDefaultSearchScope = "SCcf";
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXEnableExtensionChangeWarning = false;
      };
      CustomSystemPreferences = {
        "com.apple.universalaccess" = {
          closeViewTrackpadGestureZoomEnabled = 1;
        };
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
