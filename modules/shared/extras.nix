{
  pkgs,
  config,
  inputs,
  ...
}: {
  networking = {
  };
  fonts.packages = with pkgs; [
    # alibaba-fonts
    nerd-fonts.fira-code
    nerd-fonts.iosevka
  ];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
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
}
