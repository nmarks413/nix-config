{
  self,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/boot.nix
  ];
  programs.gamemode.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = ["nmarks"];
  };

  hardware.bluetooth.enable = true;

  services = {
  };

  programs.noisetorch.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    # dockerCompat = true;
  };
  virtualisation.docker.enable = true;

  nix.settings.trusted-users = ["root" "nmarks"];

  programs.hyprland.enable = true;

  programs.fish.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/nmarks/.dotfiles";
  };

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    supportedLocales = ["all"];

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        # fcitx5-gtk
        # kdePackages.fcitx5-qt
        rime-data
        fcitx5-rime
        fcitx5-rose-pine
      ];
    };
  };
  ### Cosmic stuff

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  systemd.packages = [pkgs.observatory];

  systemd.services.monitord.wantedBy = ["multi-user.target"];

  # Enable sound with pipewire.
  # services.pulseaudio.enable = true;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.fish;
  users.users.nmarks = {
    isNormalUser = true;
    description = "Natalie Marks";
    extraGroups = ["networkmanager" "wheel" "docker"];
    # openssh.authorizedKeys.keyFiles = ["~/.ssh/id_ed25519.pub"];
    packages = with pkgs; [
      firefox
      vim
      steam

      #  thunderbird
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  environment.variables.EDITOR = "nvim";

  programs.steam = {
    enable = true;
    package = with pkgs; steam.override {extraPkgs = pkgs: [attr];};
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  programs.kdeconnect.enable = true;

  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [22 80 443];
      enable = true;
    };
    interfaces.enp11s0.wakeOnLan = {
      enable = true;
      policy = ["magic"];
    };
  };

  programs.nix-ld.enable = true;

  # "minimum" amount of libraries needed for most games to run without steam-run
  programs.nix-ld.libraries = with pkgs; [
    # common requirement for several games
    stdenv.cc.cc.lib

    # from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/games/steam/fhsenv.nix#L72-L79
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL
    libva

    # from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/games/steam/fhsenv.nix#L124-L136
    fontconfig
    freetype
    xorg.libXt
    xorg.libXmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    libdrm
    libidn
    tbb
    zlib
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    icu
    libGL
    libappindicator-gtk3
    libdrm
    libglvnd
    libnotify
    libpulseaudio
    libunwind
    libusb1
    libuuid
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    openssl
    pango
    # pipewire
    stdenv.cc.cc
    systemd
    vulkan-loader
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
    zlib
  ];
  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
