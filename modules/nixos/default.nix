{ lib, pkgs, ... }: {
  imports = [
    ./boot.nix
    ./ld.nix
    ./nvidia.nix
    ./services.nix
  ];
  # make 'shared.darwin' not an error to define.
  options.shared.darwin = lib.mkOption {
      type = lib.types.anything;
      default = {};
      description = "no-op on linux";
  };
}
