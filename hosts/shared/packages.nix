{pkgs, ...}:
with pkgs; [
  #general development
  just
  pkg-config
  gnumake
  zed-editor
  caddy
  pm2
  clang-tools
  wget
  git
  unzip
  clang

  #productivity
  glance
  wofi
  anki-bin
  tailscale

  #nix tools
  cachix
  direnv
  comma
  nh
  podman
  docker

  #terminal stuff
  ghostty
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
  ethtool

  #linux tools
  pavucontrol
  grub2
  efibootmgr
  distrobox
  qemu
  openconnect
  wireguard-tools
  xdg-desktop-portal-gtk
  xclip

  #image tools
  imagemagick

  #chatting apps
  legcord
  webcord
  (discord.override {
    withMoonlight = true;
  })
  vesktop
  signal-desktop

  #media
  calibre
  kdePackages.dolphin
  spotify
  stremio
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
  julia
  nodePackages.npm
  go

  #gaming
  steam
  bottles
  path-of-building
  lutris
  wineWowPackages.stable
  winetricks
  dxvk_2
  mangohud
  vulkan-tools
  prismlauncher
  steam-run

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
