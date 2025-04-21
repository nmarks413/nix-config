{
  pkgs,
  userSettings,
  ...
}: {
  services.tailscale.enable = true;

  networking = {
  };
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    iosevka
    nerd-fonts.symbols-only
    nerd-fonts.iosevka
  ];

  # Set your time zone.
  time.timeZone = userSettings.timeZone;

  home-manager.users.${userSettings.username}.home.sessionVariables = {
    EDITOR = userSettings.editor;
    VISUAL = userSettings.editor;
    TERMINAL = userSettings.term;
    BROWSER = userSettings.browser;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${userSettings.theme}.yaml";

    #   pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/tinted-theming/schemes/refs/heads/spec-0.11/base16/catppuccin-mocha.yaml";
    #   hash = "sha256-+/adkhwuW/3jCJ3/EWxyz99u13yuTk9Fqqy0YZ4KPPY=";
    # };

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.${userSettings.font};
        name = "Iosevka Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.${userSettings.font};
        name = "Iosevka Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.${userSettings.font};
        name = "Iosevka Nerd Font";
      };
      emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twemoji Color";
      };
    };
  };
}
