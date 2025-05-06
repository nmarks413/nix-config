{
  pkgs,
  lib,
}: {
  # sort-lines:start
  atuin.enable = true;
  bat.enable = true;
  hyfetch.enable = true;
  direnv.enable = true;
  # sort-lines:end

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    iosevka
    nerd-fonts.symbols-only
    nerd-fonts.iosevka
  ];
}
