{
  pkgs,
  lib,
  darwinTiling,
  ...
}: {
  imports =
    [
      ./homebrew.nix
      ./system.nix
    ]
    ++ lib.optionals darwinTiling [./tiling];
}
