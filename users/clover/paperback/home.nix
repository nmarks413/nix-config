{ pkgs, ... }:
{
  # these programs are not globally installed to reduce distractions.
  # most of these are needed for my work environment.
  programs = {
    bun.enable = true;
    zsh.profileExtra = ''
      _bun() {
        local context state line
        _arguments -C '*:file:_files'
      }
    '';
  };
  home.packages = with pkgs; [
    doppler
    deno
    nodejs_22
    rustup
    typescript
    pm2
    pnpm
    yt-dlp
    spotdl
    zig
    ssm-session-manager-plugin
    awscli
  ];
}
