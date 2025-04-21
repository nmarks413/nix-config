{
  pkgs,
  config,
  inputs,
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
}
