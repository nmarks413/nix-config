# shared is used by nixos-rebuild and darwin-rebuild
{ pkgs, ... }:
{
  imports = [
    # sort-lines:start
    ./user-system-settings.nix
    ./nix.nix
    # sort-lines:end
  ];
  # install neovim globally, but let home-manager install
  # the per-user configured one.
  environment.systemPackages = [
    pkgs.neovim
  ];
}
