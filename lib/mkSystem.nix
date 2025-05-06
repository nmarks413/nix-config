# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  overlays,
  inputs,
}: name: {
  user, # ./users/{name}
  host ? null, # ./users/{name}/{host} (optional)
  system, # arch-os
  extraModules ? [],
}: let
  inherit (builtins) pathExists;
  darwin = nixpkgs.lib.strings.hasSuffix "-darwin" system;
  getInputModule = a: b:
    inputs.${
      a
    }.${
      if darwin
      then "darwinModules"
      else "nixosModules"
    }.${
      b
    };

  # NixOS vs nix-darwin functions
  systemFunc =
    if darwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;

  userDir = ../users + "/${user}";
  userConfig = import (userDir + "/user.nix");
  hostDir = userDir + "/${host}";

  hostConfigPath = hostDir + "/configuration.nix";
  userConfigPath = userDir + "/configuration.nix";
  hostHomePath = hostDir + "/home.nix";
  userHomePath = userDir + "/home.nix";

  # Arguments passed to all module files
  args = {
    inherit inputs;
    currentSystem = system;
    # Details about the host machine
    host = {
      inherit darwin;
    };
    user = ({
      # This acts as formal documentation for what is allowed in user.nix
      username, # unix username
      name, # your display name
      email, # for identity in programs such as git
      dotfilesDir, # location to `../.`
      timeZone ? "America/Los_Angeles",

      # Stylix/Theming
      theme ? null, # theme name for stylix
      sexuality ? null, # pride flag for hyfetch

      term, # preferred $TERM
      editor, # preferred $EDITOR
      browser ? null, # preferred $BROWSER
    }@user: user) userConfig;
  };
  systemSettings = rec {
    inherit darwin;
    homeDir = "/${
      if darwin
      then "Users"
      else "home"
    }/${userConfig.username}";
  };
in
  systemFunc {
    inherit system;

    modules =
      builtins.filter (f: f != null)
      [
        # Apply our overlays. Overlays are keyed by system type so we have
        # to go through and apply our system type. We do this first so
        # the overlays are available globally.
        {nixpkgs.overlays = overlays;}

        # Modules shared between nix-darwin and NixOS
        ../modules/shared
        # Modules for the specific OS
        (
          if darwin
          then ../modules/macos
          else ../modules/nixos
        )

        # The user-wide configuration.nix
        (
          if pathExists userConfigPath
          then userConfigPath
          else null
        )
        # The host-wide configuration.nix
        (
          if host != null && pathExists hostConfigPath
          then hostConfigPath
          else null
        )

        # Set up nix-index and enable comma for easy one-shot command use
        # https://github.com/nix-community/comma
        (getInputModule "nix-index-database" "nix-index")
        {programs.nix-index-database.comma.enable = true;}

        # Themes for all programs
        (getInputModule "stylix" "stylix")

        # Home manager
        (getInputModule "home-manager" "home-manager")
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            # Arguments passed to all module files
            extraSpecialArgs =
              args
              // {
                mainHomeImports = builtins.filter (f: f != null) [
                  (
                    if pathExists userHomePath
                    then userHomePath
                    else null
                  )
                  (
                    if host != null && pathExists hostHomePath
                    then hostHomePath
                    else null
                  )
                ];
              };
            # can't find how to make this an array without the param
            users.${userConfig.username} = ../modules/home-manager.nix;
          };
          users.users.${userConfig.username}.home = systemSettings.homeDir;
        }

        # Arguments passed to all module files
        {config._module.args = args;}
      ]
      # Add extra modules specified from config
      ++ extraModules;
  }
