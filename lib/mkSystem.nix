# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  overlays,
  inputs,
}: name: {
  userSettings,
  system,
  configDir, # base host config
  extraModules ? [],
}: let
  darwin = nixpkgs.lib.strings.hasSuffix "-darwin" system;

  nixindex =
    if darwin
    then inputs.nix-index-database.darwinModules.nix-index
    else inputs.nix-index-database.nixosModules.nix-index;

  stylix =
    if darwin
    then inputs.stylix.darwinModules.stylix
    else inputs.stylix.nixosModules.stylix;

  systemModuleDir =
    if darwin
    then "macos"
    else "nixos";

    # NixOS vs nix-darwin functions
    systemFunc =
      if darwin
      then inputs.darwin.lib.darwinSystem
      else nixpkgs.lib.nixosSystem;


    # The config files for this system.
    hostConfig = configDir + "/configuration.nix";
    homeConfig = configDir + "/home.nix";

    hmModules =
      if darwin
      then inputs.home-manager.darwinModules
      else inputs.home-manager.nixosModules;

  systemSettings = rec {
    inherit darwin;

    homeDir =
      if darwin
      then "/Users/" + userSettings.username + "/"
      else "/home/" + userSettings.username + "/";

  };
in
    systemFunc {
      inherit system;

      # TODO: gross and ugly hack do NOT like
      specialArgs = {
        inherit (userSettings) darwinTiling;
      };

      modules =
        [
          # Apply our overlays. Overlays are keyed by system type so we have
          # to go through and apply our system type. We do this first so
          # the overlays are available globally.
          {nixpkgs.overlays = overlays;}

          # Shared modules
          ../modules/shared

          # System specific modules
          ../modules/${systemModuleDir}

          # Link to configuration.nix
          hostConfig

          # Set up nix-index and enable comma for easy one-shot command use
          # https://github.com/nix-community/comma
          nixindex
          {programs.nix-index-database.comma.enable = true;}

          # Themes for all programs
          stylix

          hmModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = {inherit inputs userSettings systemSettings;};
              users.${userSettings.username} = homeConfig;
            };

            users.users.${userSettings.username}.home = systemSettings.homeDir;
          }

          # We expose some extra arguments so that our modules can parameterize
          # better based on these values.
          {
            config._module.args = {
              currentSystem = system;
              # currentSystemName = name;
              # currentSystemUser = userSettings.username;

              inherit inputs userSettings systemSettings;
            };
          }
        ]
        # Add extra modules specified from config
        ++ extraModules;
    }
