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

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.${userSettings.font};
        name = "${userSettings.font} Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.${userSettings.font};
        name = "${userSettings.font} Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.${userSettings.font};
        name = "${userSettings.font} Nerd Font";
      };
      emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twemoji Color";
      };
    };
  };
}
