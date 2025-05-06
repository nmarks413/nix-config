{
  config,
  pkgs,
  lib,
  ...
}: {
  # Use touchid or watch to activate sudo
  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };

  # Set some OSX preferences that I always end up hunting down and changing.
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;

    defaults = lib.mkDefault {
      # Turn quarantine off
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

        #Autohide menu bar
        #_HIHideMenuBar = config.shared.darwin.tiling;
      };
      # minimal dock
      dock = {
        autohide = true;
        autohide-time-modifier = 0.0; # make animation instant
        autohide-delay = 0.0; # remove delay when touching bottom of screen
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
        # TODO: default to list view and not saving .DS_Store
      };
      CustomSystemPreferences = {
        "com.apple.universalaccess" = {
          closeViewTrackpadGestureZoomEnabled = 1;
        };
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            "64" = {
              enabled = false;
            };
          };
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
