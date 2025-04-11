{
  inputs,
  config,
  pkgs,
  lib,
  zls,
  nix-options-search,
  ...
}: let
  shared-programs = import ../shared/home-programs.nix {inherit config pkgs lib;};
in {
  home = {
    username = "nmarks";
    homeDirectory = "/home/nmarks";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.05"; # Please read the comment before changing.

    packages = with pkgs; let
      shared-packages = import ../shared/packages.nix {inherit pkgs;};
    in
      shared-packages
      ++ [
        #building macos apps hard :(
        ghostty
        stremio
        julia

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
        (prismlauncher.override {gamemodeSupport = true;})

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
      ]
      ++ [
        zls.packages.x86_64-linux.zls
        rust-bin.stable.latest.default
      ];
    # programs.mangohud.enable = true;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "ghostty";
      BROWSER = "firefox";
    };
  };

  programs = shared-programs;

  xdg.mimeApps.defaultApplications."inode/directory" = "dolphin.desktop";
}
