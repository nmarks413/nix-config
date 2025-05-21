{
  pkgs,
  lib,
  ...
} @ args: {
  programs = {
    # sort-lines:start
    atuin.enable = true;
    bat.enable = true;
    hyfetch.enable = true;
    direnv.enable = true;
    fish.enable = true;
    man.generateCaches = false;
    # sort-lines:end
  };

  home.packages = import ./packages.nix args;
}
