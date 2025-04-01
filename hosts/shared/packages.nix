{pkgs, ...}:
with pkgs; [
  #general development
  just
  pkg-config
  gnumake
  caddy
  pm2
  clang-tools
  wget
  git
  unzip
  clang

  #ides
  zed-editor
  emacs

  #virtualization
  qemu
  podman
  docker

  #productivity
  glance
  anki-bin
  tailscale
  openconnect
  wireguard-tools

  #nix tools
  cachix
  direnv
  comma
  nh

  #terminal stuff
  (btop.override {cudaSupport = true;})
  tmux
  zellij
  lazygit
  fzf
  neofetch
  hyfetch
  fastfetch
  bat
  eza
  ollama
  uv
  fd
  ripgrep
  file
  fish

  #image tools
  imagemagick

  #chatting apps
  (discord.override {
    withMoonlight = true;
  })
  vesktop
  signal-desktop

  #media
  spotify
  qbittorrent
  mpv

  #language servers
  typst-live
  lua-language-server
  nil
  texlab
  texlivePackages.chktex

  #formatters/linters
  stylua
  alejandra
  statix

  #neovim deps
  lua51Packages.lua
  lua51Packages.luarocks-nix
  codespell
  typst

  #python
  pyright
  basedpyright
  ruff
  python312Packages.python
  python312Packages.pynvim
  python312Packages.pip

  #programming languages
  R
  deno
  ruby
  nodePackages.npm
  go
  coq

  #gaming
  prismlauncher

  #browsers
  tor
  firefox

  #math
  texlive.combined.scheme-full

  #fun things
  cowsay
  cmatrix
  sl
]
