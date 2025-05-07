{
  inputs,
  config,
  pkgs,
  lib,
  user,
  host,
  ...
} @ args: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    #set up nixvim
    # ../../modules/nixvim
  ];
  home = {
    stateVersion = "23.05"; # Please read the comment before changing.
    # shell = pkgs.fish;

    sessionPath = [
      "$HOME/.emacs.d/bin"
    ];
  };
}
