{
  pkgs,
  user,
  host,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  documentation.man.generateCaches = false;
  programs = {
    gamemode.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ user.username ];
    };

    noisetorch.enable = true;

    fish.enable = true;
    virt-manager.enable = true;

    nh = {
      enable = true;
      # clean.enable = true;
      # clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/nmarks/.dotfiles#nixosConfigurations.nixos";
    };

    steam = {
      enable = true;
      package = with pkgs; steam.override { extraPkgs = pkgs: [ attr ]; };
    };

    git = {
      enable = true;
      lfs.enable = true;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    kdeconnect.enable = true;
  };

  hardware.bluetooth.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      # dockerCompat = true;
    };
    docker.enable = true;

    libvirtd.enable = true;
  };

  nix.settings.trusted-users = [
    "root"
    user.username
  ];
  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    services.monitord.wantedBy = [ "multi-user.target" ];
  };

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    supportedLocales = [ "all" ];

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

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.xwayland.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.defaultUserShell = pkgs.fish;
  users.users.${user.username} = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = user.name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    # openssh.authorizedKeys.keyFiles = ["~/.ssh/id_ed25519.pub"];
    packages = with pkgs; [
      firefox
      vim
      steam

      #  thunderbird
    ];
  };
  environment = {
    sessionVariables = {
      COSMIC_DATA_CONTROL_ENABLED = 1;
      NIXOS_OZONE_WL = "1";
    };
    variables.EDITOR = "nvim";

    systemPackages = with pkgs; [
      vim
    ];
  };

  networking = {
    hostName = host.name; # Define your hostname.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [
        22
        80
        443
      ];
      enable = true;
    };
    interfaces.enp11s0.wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };
  };

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
