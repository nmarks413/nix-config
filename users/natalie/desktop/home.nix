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
  programs.mangohud.enable = true;
  home = {
    stateVersion = "23.05"; # Please read the comment before changing.

    packages = with pkgs; [
      #building macos apps hard :(
      ghostty
      stremio
      julia
      qbittorrent

      #gaming
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
      umu-launcher
      limo
      nexusmods-app-unfree
      protontricks

      #window manager stuff
      wofi
      xorg.xauth
      #linux tools
      legcord
      pavucontrol
      ethtool
      grub2
      efibootmgr
      distrobox
      xdg-desktop-portal-gtk
      xclip
      kdePackages.dolphin
      #broken on macos
      calibre
      mpv
      wireguard-tools
      signal-desktop
      inputs.zls.packages.x86_64-linux.zls
      rust-bin.stable.latest.default
      inputs.zen-browser.packages.x86_64-linux.default
    ];
  };

  # xdg.mimeApps.defaultApplications."inode/directory" = "dolphin.desktop";
}
