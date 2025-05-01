{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./ld.nix
    ./nvidia.nix
    ./services.nix
  ];
}
