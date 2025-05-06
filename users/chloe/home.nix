{
  inputs,
  pkgs,
  lib,
  ...
}: {
  home = {
    stateVersion = "23.05"; # Please read the comment before changing.
    packages = [
      pkgs.neovim
      pkgs.nh
      pkgs.ffmpeg
    ];
  };
  programs = {
    # sort-lines:start
    hyfetch.enable = true;
    zsh.enable = true;
    # sort-lines:end

    # use a git-specific email
    git.userEmail = "git@paperclover.net";
  };
}
