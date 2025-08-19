{
  inputs,
  config,
  pkgs,
  lib,
  userSettings,
  systemSettings,
  ...
}:

{
  home = {
    stateVersion = "23.05"; # Don't change this unless upgrading Home Manager versions

    packages = with pkgs; [
      # General applications
      ghostty
      stremio
      julia
      calibre
      mpv
      signal-desktop
      python3
      gh
      spotify

      # Gaming
      (prismlauncher.override { gamemodeSupport = true; })

      # System & desktop tools
      wofi
      xorg.xauth
      kdePackages.dolphin
      xdg-desktop-portal-gtk
      xclip
      pavucontrol
      ethtool
      grub2
      efibootmgr
      distrobox
      pqiv

      # Dev tools
      legcord
      hyfetch
      kicad

      # Unsorted
      ripgrep
      busybox
      imagemagick
    ];
  };

  programs = {
    btop.enable = true;
    hyfetch.enable = true;

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    # Uncomment if you want to use MangoHud system-wide
    # mangohud.enable = true;
  };
}
