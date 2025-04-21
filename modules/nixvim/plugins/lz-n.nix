{pkgs, ...}: {
  programs.nixvim.programs = {
    lz-n = {
      enable = true;
    };
  };
}
