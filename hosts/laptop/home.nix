{
  inputs,
  config,
  pkgs,
  lib,
  userSettings,
  ...
}: {
  programs = import ../shared/home-programs.nix {inherit inputs config pkgs lib userSettings;};

  home = {
    inherit (userSettings) username;
    # homeDirectory = systemSettings.homeConfig;
    # shell = pkgs.fish;
    stateVersion = "23.05"; # Please read the comment before changing.

    packages = pkgs.callPackage ../shared/packages.nix {};

    sessionPath = [
      "$HOME/.emacs.d/bin"
    ];
  };
}
