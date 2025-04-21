{
  pkgs,
  config,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.latest;
in {
  services.xserver.videoDrivers = ["nvidia"];

  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfree = true;
  };
  # Kernel parameters for better Wayland and Hyprland integration
  boot.kernelParams = [
    "nvidia-drm.modeset=1" # Enable mode setting for Wayland
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Improves resume after sleep
  ];

  # Blacklist nouveau to avoid conflicts
  boot.blacklistedKernelModules = ["nouveau"];
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia"; # Hardware video acceleration
    XDG_SESSION_TYPE = "wayland"; # Force Wayland
    GBM_BACKEND = "nvidia-drm"; # Graphics backend for Wayland
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # Use Nvidia driver for GLX
    WLR_NO_HARDWARE_CURSORS = "1"; # Fix for cursors on Wayland
    NIXOS_OZONE_WL = "1"; # Wayland support for Electron apps
    __GL_GSYNC_ALLOWED = "1"; # Enable G-Sync if available
    __GL_VRR_ALLOWED = "1"; # Enable VRR (Variable Refresh Rate)
    WLR_DRM_NO_ATOMIC = "1"; # Fix for some issues with Hyprland
    NVD_BACKEND = "direct"; # Configuration for new driver
    MOZ_ENABLE_WAYLAND = "1"; # Wayland support for Firefox
  };

  hardware = {
    nvidia = {
      forceFullCompositionPipeline = true; # Prevents screen tearing
      # Modesetting is required.
      modesetting.enable = true;

      powerManagement = {
        enable = true; # Power management
        # finegrained = true; # More precise power consumption control
      };

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Environment variables for better compatibility

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      package = nvidiaDriverChannel;

      #Fixes a glitch
      nvidiaPersistenced = true;
    };
    nvidia-container-toolkit.enable = true;

    graphics = {
      enable = true;
      package = nvidiaDriverChannel;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
        mesa
        egl-wayland
        vulkan-loader
        vulkan-validation-layers
        libva
      ];
    };
  };

  nix.settings = {
    substituters = ["https://cuda-maintainers.cachix.org"];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    glxinfo
    libva-utils # VA-API debugging tools
  ];
}
