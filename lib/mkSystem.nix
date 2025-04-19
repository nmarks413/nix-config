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
  # mkIfElse = p: yes: no:
  #   nixpkgs.lib.mkMerge [
  #     (nixpkgs.lib.mkIf p yes)
  #     (nixpkgs.lib.mkIf (!p) no)
  #   ];
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

  # NixOS vs nix-darwin functions
  systemFunc =
    if darwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;

  home-manager =
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
        ../modules/shared/nix.nix
        ../modules/shared/extras.nix

        hostConfig
        nixindex
        home-manager.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = {inherit inputs;};
          };
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
