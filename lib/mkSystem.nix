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
  # True if this is a WSL system.
  # True if Linux, which is a heuristic for not being Darwin.
  mkIfElse = p: yes: no:
    nixpkgs.lib.mkMerge [
      (nixpkgs.lib.mkIf p yes)
      (nixpkgs.lib.mkIf (!p) no)
    ];

  nixindex = mkIfElse darwin inputs.nix-index-database.darwinModules.nix-index inputs.nix-index-database.nixosModules.nix-index;

  host = mkIfElse darwin "laptop" "desktop";

  # The config files for this system.

  hostConfig = ../hosts/${host}/configuration.nix;

  # NixOS vs nix-darwin functions
  systemFunc = mkIfElse darwin inputs.darwin.lib.darwinSystem nixpkgs.lib.nixosSystem;
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
        {inputs.programs.nix-index-database.comma.enable = true;}
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
