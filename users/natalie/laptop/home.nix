{
  inputs,
  config,
  pkgs,
  lib,
  user,
  host,
  ...
}@args:
{
  home = {
    stateVersion = "23.05"; # Please read the comment before changing.
    # shell = pkgs.fish;

    sessionPath = [
      "$HOME/.emacs.d/bin"
    ];

    packages = with pkgs; [
      #PDF viewer for VimTeX
      skimpdf
    ];
  };
}
