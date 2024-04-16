{
  config,
  pkgs,
  systemSettings,
  ...
}: {
  imports = [./hardware-configuration.nix];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation.libvirtd.enable = true;

  time.timeZone = systemSettings.timeZone;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "Iosevka"];})
  ];

  services = {
    flatpak.enable = true;
    tailscale.enable = true;
    services.keyd = {
      enable = true;
      keyboards.default.settings.main.capslock = "escape";
    };
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      displayManager.sddm.enable = true;
      desktopManager.plasma6 = true;
    };
    
  };

  programs = {
    fish.enable = true;
    virt-manager.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    pulseaudio.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  i18n = {
    defaultLocale = "en_US.utf-8";
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
  };
}
