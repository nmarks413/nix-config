{pkgs, ...}: {
  imports = [
    ../../modules/macos/homebrew.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
    pinentry_mac
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true; # default shell on catalina
  };

  # When opening an interactive shell that isnt fish move into fish
  programs.zsh = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps -p $PPID -o comm) != "fish" && -z ''${ZSH_EXUCTION_STRING} ]]
      then
        [[ -o login ]] && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  #Use touchid or watch to activate sudo
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
      # Turn quaranite off
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        # Show extensions in finder
        AppleShowAllExtensions = true;
        #Turn off the hold and press to input special chars
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        #Turn off beep noise in terminal
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
        #instant hide and show
        autohide-time-modifier = 0.0;
        show-process-indicators = true;

        expose-group-apps = true;

        show-recents = true;
        static-only = true;

        # Scale instead of shrink
        mineffect = "scale";

        orientation = "bottom";
      };
      # Better finder settings
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

    # Bind caps to escape for better normal mode stuff
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
