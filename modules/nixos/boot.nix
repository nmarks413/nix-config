{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.
    loader = {
      efi = {
        canTouchEfiVariables = true;
        # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        # theme = pkgs.catppuccin-grub;
        useOSProber = true;
        efiSupport = true;
      };
    };

    #this is set to false by default for some reason
    tmp.cleanOnBoot = true;

    # Make boot screen quiet
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
