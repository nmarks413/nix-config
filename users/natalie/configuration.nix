# Applied to all systems
{
  inputs,
  pkgs,
  host,
  ...
}:
{
  services.tailscale.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    iosevka
    nerd-fonts.symbols-only
    nerd-fonts.iosevka
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro
  ];

  # configuration for shared modules.
  # all custom options in 'shared' for clarity.
  shared.darwin = {
    tiling.enable = host.darwin; # use tiling window manager
  };
}
