# Configuration applied to all of chloe's machines
{pkgs, ...}: {
  # packages for all machines
  environment.systemPackages = with pkgs; [
    neovim
  ];
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
    CustomUserPreferences = {
      NSGlobalDomain = {
        # TODO: how to change system accent color
        AppleHighlightColor = "1.000000 0.874510 0.701961 Orange";
      };
    };
  };
}
