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
      qbittorrent
      calibre
      mpv
      signal-desktop
      python3
      gh

      # Gaming
      bottles
      lutris
      mangohud
      dxvk_2
      steam-run
      vulkan-tools
      path-of-building
      wineWowPackages.stable
      winetricks
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

      # Dev tools
      legcord
      hyfetch
      arduino-cli
      rust-bin.stable.latest.default
      tytools
      inputs.zls.packages.x86_64-linux.zls
      platformio
      usbutils
      teensy-loader-cli
      teensyduino
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
