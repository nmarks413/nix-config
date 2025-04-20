{
  pkgs,
  config,
  inputs,
  ...
}: {
  services.tailscale.enable = true;

  networking = {
  };
  fonts.packages = with pkgs; [
    # alibaba-fonts
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    iosevka
    nerd-fonts.symbols-only
    nerd-fonts.iosevka
  ];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
}
