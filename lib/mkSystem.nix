# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  overlays,
  inputs,
  userSettings,
}: name: {
  system,
  darwin ? false,
  extraModules ? [],
}: let
  # userSettings = rec {
  #   username = "nmarks"; # username
  #   name = "Natalie"; # name/identifier
  #   email = "nmarks413@gmail.com"; # email (used for certain configurations)
  #   dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
  #   browser = "firefox"; # Default browser; must select one from ./user/app/browser/
  #   term = "ghostty"; # Default terminal command;
  #   font = "iosevka Nerd Font"; # Selected font
  #   editor = "neovim"; # Default editor;
  #   spawnEditor = "exec" + term + "- e " + editor;
  # };
  nixindex =
    if darwin
    then inputs.nix-index-database.darwinModules.nix-index
    else inputs.nix-index-database.nixosModules.nix-index;

  systemSettings = rec {
    host =
      if darwin
      then "laptop"
      else "desktop";

    # The config files for this system.

    hostConfig = ../hosts/${host}/configuration.nix;
    homeConfig = ../hosts/${host}/home.nix;

    homeDir =
      if darwin
      then "/Users/" + userSettings.username + "/"
      else "/home/" + userSettings.username + "/";

    # NixOS vs nix-darwin functions
    systemFunc =
      if darwin
      then inputs.darwin.lib.darwinSystem
      else nixpkgs.lib.nixosSystem;

    hmModules =
      if darwin
      then inputs.home-manager.darwinModules
      else inputs.home-manager.nixosModules;
  };
in
  with systemSettings;
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
              extraSpecialArgs = {inherit inputs userSettings systemSettings;};
              users.${userSettings.username} = homeConfig;
            };

            users.users.${userSettings.username}.home = homeDir;
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
        ++ extraModules;
    }
