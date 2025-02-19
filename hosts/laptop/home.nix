{
  inputs,
  config,
  pkgs,
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

  nixpkgs.config = {
    allowUnfree = true;
  };

  # imports = [
  #   ./zed-editor.nix
  # ];

  # imports = [discord/default.nix];
  # sys.discord.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs; [
    # ghostty.packages.aarch64-darwin.default
    python312
    uv
    fd
    lua51Packages.lua
    lua51Packages.luarocks
    luajitPackages.magick
    ripgrep
    lemonade
    anki-bin
    wireguard-tools
    ruff
    python312Packages.jedi-language-server
    tor
    #spotify
    #stremio
    fzf
    zigpkgs.master
    stylua
    cachix
    btop
    neofetch
    direnv
    tmux
    zellij
    qemu
    vimgolf
    lazygit
    rustup
    file
    vesktop
    discord
    # itch : THIS IS BROKEN FOR SOME REASON, need to pin it??
    qbittorrent
    deno
    imagemagick
    pkg-config
    #mpv
    comma
    gnumake
    #signal-desktop
    #zed-editor
    #getting foundry to work!
    #nodejs_21
    #productivty
    #todoist-electron
    #Gaming
    prismlauncher
    # for cmpm17
    # binwalk
    exiftool
    #for fun
    cowsay
    cmatrix
    hyfetch
    bat
    eza
    ollama
    sl
    #LSP + formatters/linters
    texlivePackages.chktex
    lua-language-server
    nil
    alejandra
    statix
    texlab
    clang-tools
    # rust-analyzer
    #clippy
    # rustfmt
    #runpod
    docker
    nh
    fastfetch
  ];
  programs.direnv = {
    enable = true;
    #enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    extraLuaPackages = ps: [ps.magick];
    extraPackages = [pkgs.imagemagick];
  };
  #Link neovim config into nix
  #xdg.configFile.nvim.source = ./nvim;
  #xdg.mimeApps.defaultApplications."inode/directory" = "dolphin.desktop";
  # xdg.mimeApps.defaultApplications = {"inode/directory" = "org.kde.dolphin.desktop";};

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    daemon.enable = false;
  };

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
    shellAliases = {
      # DYLD_FALLBACK_LIBRARY_PATH = "$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH";
    };
  };

  programs.moonlight-mod = {
    enable = true;
    stable = {
      extensions = {
        allActivites.enabled = true;
        alwaysFocus.enabled = true;

        betterEmbedsYT = {
          enabled = true;
          config = {
            fullDescription = false;
            expandDescription = true;
          };
        };
      };
    };
  };

  programs.hyfetch = {
    enable = true;
    settings = {
      backend = "fastfetch";
      preset = "bisexual";
      mode = "rgb";
      light_dark = "dark";
      lightness = {
      };
      color_align = {
        mode = "horizontal";
        # custom_colors = [];
        # fore_back = null;
      };
      distro = null;
      pride_month_shown = [
      ];
      pride_month_disable = false;
    };
  };

  /*
    programs.zsh = {
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "extract"];
    };
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {name = "powerlevel10k";src = pkgs.zsh-powerlevel10k;file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";}
    ];
  };
  */

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nmarks/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "ghostty";
    BROWSER = "firefox";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
