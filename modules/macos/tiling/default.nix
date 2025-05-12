{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./sketchybar.nix
    ./aerospace.nix
  ];
  options = {
    shared.darwin.tiling.enable = lib.mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable tiling window management.";
    };
  };
}
