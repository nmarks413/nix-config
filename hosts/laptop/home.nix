{
  inputs,
  config,
  pkgs,
  lib,
  ghostty,
  moonlight,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = pkgs.callPackage ../shared/packages.nix {};

  programs = import ../shared/home-programs.nix {inherit config pkgs lib;};

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "ghostty";
    BROWSER = "firefox";
  };
  home.sessionPath = [
    "$HOME/.emacs.d/bin"
  ];

  # Let Home Manager install and manage itself.
}
