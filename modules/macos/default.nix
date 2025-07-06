{
  lib,
  ...
}:
{
  imports = [
    # sort-lines: start
    ./mac-app-store.nix
    ./system.nix
    ./icons.nix
    ./tiling
    # sort-lines: end
  ];
  # make 'shared.linux' not an error to define.
  options.shared.linux = lib.mkOption {
    type = lib.types.anything;
    default = { };
    description = "no-op on darwin";
  };
}
