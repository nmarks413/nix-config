# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  overlays,
  inputs,
}: name: {
  system,
  user,
  darwin ? false,
  extraModules ? [],
}: let
  nixindex =
    if darwin
    then inputs.nix-index-database.darwinModules.nix-index
    else inputs.nix-index-database.nixosModules.nix-index;

  host =
    if darwin
    then "laptop"
    else "desktop";

  # The config files for this system.

  hostConfig = ../hosts/${host}/configuration.nix;
  homeConfig = ../hosts/${host}/home.nix;

  homeDir =
    if darwin
    then "/Users/nmarks/"
    else "/home/nmarks";

  # NixOS vs nix-darwin functions
  systemFunc =
    if darwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;

  hmModules =
    if darwin
    then inputs.home-manager.darwinModules
    else inputs.home-manager.nixosModules;
in
  systemFunc rec {
    inherit system;

    modules =
      [
        # Apply our overlays. Overlays are keyed by system type so we have
        # to go through and apply our system type. We do this first so
        # the overlays are available globally.
        {nixpkgs.overlays = overlays;}

        # Enable caching for nix-index so we dont have to rebuild it

        #shared modules
        ../modules/shared/extras.nix
        ../modules/shared/nix.nix

        hostConfig
        nixindex
        {programs.nix-index-database.comma.enable = true;}
        hmModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = {inherit inputs user;};
            users.${user} = homeConfig;
          };

          users.users.${user}.home = homeDir;
        }

        # We expose some extra arguments so that our modules can parameterize
        # better based on these values.
        {
          config._module.args = {
            currentSystem = system;
            currentSystemName = name;
            currentSystemUser = user;
            inherit inputs;
          };
        }
      ]
      ++ extraModules;
  }
