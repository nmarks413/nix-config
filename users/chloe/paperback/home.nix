{pkgs, ...}: {
  # these programs are not globally installed to reduce distractions.
  # most of these are needed for my work environment.
  programs.bun.enable = true;
  programs.zed-editor.enable = true;
  home.packages = with pkgs; [
    doppler
    nodejs_22
    rustup
    typescript
    pm2
    pnpm
  ];
}
