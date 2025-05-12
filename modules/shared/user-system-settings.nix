# applies user settings for the system
{
  config,
  pkgs,
  user,
  lib,
  ...
}:
{
  # Set your time zone.
  time.timeZone = user.timeZone;

  home-manager.users.${user.username}.home.sessionVariables =
    {
      EDITOR = user.editor;
      TERMINAL = user.term;
    }
    // lib.optionalAttrs (user ? "browser") {
      BROWSER = user.browser;
    };

  stylix = lib.mkIf (user ? "theme" && user.theme != null) {
    enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${user.theme}.yaml";

    fonts = lib.optionalAttrs (user ? "font") {
      serif = {
        package = pkgs.nerd-fonts.${user.font};
        name = "${user.font} Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.${user.font};
        name = "${user.font} Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.${user.font};
        name = "${user.font} Nerd Font";
      };
      emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twemoji Color";
      };
    };
  };
}
