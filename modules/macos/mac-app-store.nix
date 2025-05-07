{
  config,
  lib,
  pkgs,
  ...
}: let
  types = lib.types;

  # Mapping of Mac App Store applications.
  # Add new entries to this list via the App Store's share button
  # https://apps.apple.com/us/app/logic-pro/id634148309?mt=12
  #                                           --------- ID HERE
  allMasApps = {
    # sort-lines:start
    adguard = 1440147259;
    final-cut-pro = 424389933;
    logic-pro = 634148309;
    magnet = 441258766;
    motion = 434290957;
    wireguard = 1451685025;
    # sort-lines:end
  };

  # the resolved configuration from the user
  masApps = config.shared.darwin.macAppStoreApps;
in {
  options = {
    # Installs Mac Applications via name using homebrew.
    shared.darwin.macAppStoreApps = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
  config = lib.mkIf (builtins.length masApps > 0) {
    homebrew.enable = true;
    homebrew.masApps = builtins.listToAttrs (
      builtins.map (name: {
        inherit name;
        value = allMasApps.${name};
      })
      masApps
    );
  };
}
