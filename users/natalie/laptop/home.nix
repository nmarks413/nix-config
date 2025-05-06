{
  inputs,
  config,
  pkgs,
  lib,
  userSettings,
  systemSettings,
  ...
} @ args: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    #set up nixvim
    # ../../modules/nixvim
  ];
  programs = import ./home-programs.nix args;

  home = {
    inherit (userSettings) username;
    # shell = pkgs.fish;
    stateVersion = "23.05"; # Please read the comment before changing.

    packages = pkgs.callPackage ../../modules/shared/packages.nix {inherit systemSettings;};

    sessionPath = [
      "$HOME/.emacs.d/bin"
    ];
  };
}
