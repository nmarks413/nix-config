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

}
