{
  inputs,
  config,
  pkgs,
  lib,
  userSettings,
  systemSettings,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    #set up nixvim
    ../../modules/nixvim
  ];
  programs = import ../../modules/shared/homeManagerPrograms.nix {inherit inputs config pkgs lib userSettings systemSettings;};

  home = {
    inherit (userSettings) username;
    # homeDirectory = systemSettings.homeConfig;
    # shell = pkgs.fish;
    stateVersion = "23.05"; # Please read the comment before changing.

    packages = pkgs.callPackage ../../modules/shared/packages.nix {};

    sessionPath = [
      "$HOME/.emacs.d/bin"
    ];
  };
}
