#<BS> Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  services = {
    ratbagd.enable = true;
  };

  systemd.timers.duckdns = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "duckdns.service";
    };
  };

  programs.noisetorch.enable = true;

  systemd.services.duckdns = {
    enable = true;
    script = ''echo url="https://www.duckdns.org/update?domains=pathfinder2e&token=9c1ffa47-7496-4975-ba2b-a6928b28c500&ip=" | ${pkgs.curl}/bin/curl -v -k -o ~/.duckdns/duck.log -K -'';
    serviceConfig = {
      Type = "oneshot";
      User = "nmarks";
    };
  };

  services.foundryvtt = {
    enable = true;
    hostName = "pathfinder2.duckdns.org";
    proxySSL = true;
    proxyPort = 443;
    package = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt_11;
  };

  services.cloudflared = {
    enable = true;
    # user = "nmarks";
    # tunnels = {
    #   "b407af0f-5168-4a79-a9f4-fe99e52990dd" = {
    #     credentialsFile = "${config.users.users.nmarks.home}/.cloudflared/b407af0f-5168-4a79-a9f4-fe99e52990dd.json";
    #     default = "http_status:404";
    #   };
    # };
  };

  services.caddy = {
    enable = true;

    # virtualHosts."10.154.1.147".extraConfig = ''
    #   tls internal
    #   reverse_proxy localhost:30000
    #   encode zstd gzip
    # '';

    # virtualHosts."10.154.1.105".extraConfig = ''
    #   tls internal
    #   reverse_proxy localhost:30000
    #   encode zstd gzip
    # '';
    #
    # virtualHosts."pathfinder2e.duckdns.org".extraConfig = ''
    #   reverse_proxy localhost:30000
    #   encode zstd gzip
    # '';
    virtualHosts."pathfinder2e.duckdns.org".extraConfig = ''
      reverse_proxy localhost:30000
    '';

    # extraConfig = ''
    #   pathfinder2e.duckdns.org {
    #       # PROXY ALL REQUEST TO PORT 30000
    #       reverse_proxy localhost:30000
    #       encode zstd gzip
    #   }
    # '';
  };

  services.flatpak.enable = true;

  virtualisation.docker.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  programs.hyprland.enable = true;

  programs.fish.enable = true;

  services.tailscale.enable = true;

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
            capslock = "escape";
          };
        };
      };
    };
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "Iosevka"];})
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.foundryvtt.nixosModules.foundryvtt
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    forceFullCompositionPipeline = true;
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
    #Fixes a glitch
    nvidiaPersistenced = true;

    #Required for amdgpu and nvidia gpu pairings
    # modesetting.enable = true;

    prime = {
      # offload.enable = true;
      #sync.enable = true;

      amdgpuBusId = "PCI:0f:00.0";

      nvidiaBusId = "PCI:01:00.0";
    };
  };
  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    # grub = {
    #   enable = true;
    #   device = "/dev/sdb1";
    #   theme = pkgs.nixos-grub2-theme;
    #   useOSProber = true;
    # };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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
      kate
      vim
      kitty
      lua-language-server
      texlive.combined.scheme-full
      steam-run
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

  # Allow unfree packages
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fish
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    unzip
    ripgrep
    clang
    fd
    cargo
    python3
    python311Packages.pynvim
    python311Packages.pip
    steam
    ruby
    julia
    xclip
    nodePackages.npm
    go
    tailscale
    ethtool
    grub2
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.kdeconnect.enable = true;

  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [22 80 443];
      #KDE Connect
      # allowedTCPPortRanges = [
      #   {
      #     from = 1714;
      #     to = 1764;
      #   }
      # ];
      # allowedUDPPortRanges = [
      #   {
      #     from = 1714;
      #     to = 1764;
      #   }
      # ];
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
    pipewire
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
