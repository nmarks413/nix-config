{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # sort-lines: start
    ./mac-app-store.nix
    ./system.nix
    ./icons.nix
    # sort-lines: end
  ];
}
