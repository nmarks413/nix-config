# Configuration applied to all of clover's machines
{ pkgs, ... }:
{
  # packages for all machines
  environment.systemPackages = with pkgs; [
    git
  ];

  services.tailscale.enable = true;

  # configuration for shared modules.
  # all custom options in 'shared' for clarity.
  shared.darwin = {
    macAppStoreApps = [
      "adguard"
      "magnet"
    ];
  };

  # system preferences
  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
    };
    dock = {
      show-recents = false;
    };
    CustomUserPreferences = {
      NSGlobalDomain = {
        # TODO: how to change system accent color
        AppleHighlightColor = "1.000000 0.874510 0.701961 Orange";

        # control how the fn keys operate
        # 0 = default to media keys, 1 = default to FN1-12
        "com.apple.keyboard.fnState" = 1;

        NSUserKeyEquivalents = {
          Minimize = "@~^\\Uf70f"; # set minimize to a stupidly hard key to press
        };
      };
    };
  };
}
