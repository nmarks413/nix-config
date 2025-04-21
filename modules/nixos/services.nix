{pkgs, ...}: {
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    blueman.enable = true;
    ratbagd.enable = true;
    flatpak.enable = true;
    keyd = {
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

    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;

    # Auto mount devices
    udisks2 = {
      enable = true;
    };
    # Configure keymap in X11
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };

    tailscale.enable = true;

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [pkgs.brlaser]; # Brother printer driver
    };

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # systemWide = true;
      #media-session.enable = true;
    };

    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = true;
        UseDns = true;
        X11Forwarding = true;
      };
    };
  };
}
