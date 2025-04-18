{
  inputs,
  pkgs,
  config,
  lib,
  mkIfElse,
  ...
}: let
  darwin = pkgs.stdenv.isDarwin;
  homemanagerModules = mkIfElse darwin inputs.home-manager.darwinModules inputs.home-manager.nixosModules;
  nixindex = mkIfElse darwin inputs.nix-index-database.darwinModules.nix-index inputs.nix-index-database.nixosModules.nix-index;
in {
  config.var = {
    inherit darwin homemanagerModules nixindex;
  };

  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
