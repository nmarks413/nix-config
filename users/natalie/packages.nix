# Packages installed with home-manager
{ pkgs, ... }:
with pkgs;
[
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
  cmake
  gnupg
  typescript-language-server
  deno

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

  #nix tools
  direnv
  nh

  #terminal stuff
  (btop.override { cudaSupport = true; })
  tmux
  zellij
  lazygit
  fzf
  neofetch
  hyfetch
  fastfetch
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
  (discord.override { withMoonlight = true; })
  vesktop

  #media
  spotify

  #language servers
  typst-live

  #formatters/linters
  stylua
  alejandra
  statix

  #neovim deps
  # TODO: from clo, maybe u can remove all of these? i don't wanna break tho
  tree-sitter
  zathura
  #python
  pyright
  ruff
  python312Packages.python
  python312Packages.pynvim
  python312Packages.pip

  #programming languages
  deno
  ruby
  pnpm
  nodejs_24
  # nodePackages.npm
  go
  elan

  #expo deps
  watchman
  zulu17
  android-tools

  #browsers
  tor
  firefox

  #math
  # texlive.combined.scheme-full

  #fun things
  cowsay
  cmatrix
  sl
]
