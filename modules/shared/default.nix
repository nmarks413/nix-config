# shared is used by nixos-rebuild and darwin-rebuild
{pkgs, ...}: {
  imports = [
    # sort-lines:start
    ./user-system-settings.nix
    ./nix.nix
    # sort-lines:end
  ];
}
