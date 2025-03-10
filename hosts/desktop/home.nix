{
  inputs,
  config,
  pkgs,
  zls,
  nix-options-search,
  ...
}: {
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   # ...
  #   plugins = [
  #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
  #     # ...
  #   ];
  # };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nmarks";
  home.homeDirectory = "/home/nmarks";

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

  home.packages = with pkgs;
    [
      glance
      rust-bin.stable.latest.default
      just
      libxkbcommon
      imagemagick
      lua51Packages.lua
      lua51Packages.luarocks-nix
      legcord
      calibre
      pyright
      ruff
      python312Packages.jedi-language-server
      wofi
      bottles
      kdePackages.dolphin
      path-of-building
      tor
      spotify
      stremio
      codespell
      fzf
      pavucontrol
      efibootmgr
      zigpkgs.master
      ghostty
      stylua
      webcord
      cachix
      (btop.override {cudaSupport = true;})
      neofetch
      direnv
      R
      typst
      typst-live
      tmux
      zellij
      distrobox
      podman
      qemu
      vimgolf
      lazygit
      file
      vesktop
      (discord.override {
        withMoonlight = true;
      })
      # itch : THIS IS BROKEN FOR SOME REASON, need to pin it??
      qbittorrent
      deno
      imagemagick
      pkg-config
      mpv
      comma
      openconnect
      gnumake
      signal-desktop
      zed-editor
      #getting foundry to work!
      #nodejs_21
      caddy
      cloudflared
      pm2
      #productivty
      #Gaming
      lutris
      wineWowPackages.stable
      winetricks
      dxvk_2
      mangohud
      vulkan-tools
      prismlauncher
      # for cmpm17
      exiftool
      #for fun
      cowsay
      cmatrix
      hyfetch
      bat
      eza
      ollama
      sl
      fallout-ce
      fallout2-ce
      #LSP + formatters/linters
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
    ]
    ++ [zls.packages.x86_64-linux.zls];

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    daemon.enable = true;
  };

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
  xdg.mimeApps.defaultApplications."inode/directory" = "dolphin.desktop";
  # xdg.mimeApps.defaultApplications = {"inode/directory" = "org.kde.dolphin.desktop";};

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    extraConfig = "font_family Iosevka NF
                   italic_font auto
                   bold_italic_font  auto
                   bold_font  auto";
  };

  programs.mangohud.enable = true;

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
    shellAliases = {
      # hm-update = "git add home.nix ; git commit -m 'updated home-manager config'; git push origin main; home-manager switch --flake ~/.dotfiles/#nmarks";
      # sys-update = "git add configuration.nix ; git commit -m 'updated system config'; git push origin main; sudo nixos-rebuild switch --flake ~/.dotfiles/#nmarks";
      # full-update = "sys-update; hm-update";
      reboot-windows = "sudo efibootmgr --bootnext 0000; sudo reboot -h now";
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

  services.glance = {
    enable = true;
    settings = {
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                  first-day-of-week = "monday";
                }
                {
                  type = "rss";
                  limit = 10;
                  collapse-after = 3;
                  cache = "12h";
                  feeds = [
                    {
                      url = "https://selfh.st/rss/";
                      title = "selfh.st";
                      limit = 4;
                    }
                    {url = "https://ciechanow.ski/atom.xml";}
                    {
                      url = "https://www.joshwcomeau.com/rss.xml";
                      title = "Josh Comeau";
                    }
                    {url = "https://samwho.dev/rss.xml";}
                    {
                      url = "https://ishadeed.com/feed.xml";
                      title = "Ahmad Shadeed";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "group";
                  widgets = [{type = "hacker-news";} {type = "lobsters";}];
                }
                {
                  type = "videos";
                  channels = ["UCXuqSBlHAE6Xw-yeJA0Tunw" "UCR-DXc1voovS8nhAvccRZhg" "UCsBjURrPoezykLs9EqgamOA" "UCBJycsmduvYEL83R_U4JriQ" "UCHnyfMqiRRG1u-2MsSQLbXA"];
                }
                {
                  type = "group";
                  widgets = [
                    {
                      type = "reddit";
                      subreddit = "technology";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "selfhosted";
                      show-thumbnails = true;
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "London, United Kingdom";
                  units = "metric";
                  hour-format = "12h";
                }
                {
                  type = "markets";
                  symbol-link-template = "https://www.tradingview.com/symbols/{SYMBOL}/news";
                  markets = [
                    {
                      symbol = "SPY";
                      name = "S&P 500";
                    }
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "NVDA";
                      name = "NVIDIA";
                    }
                    {
                      symbol = "AAPL";
                      name = "Apple";
                    }
                    {
                      symbol = "MSFT";
                      name = "Microsoft";
                    }
                  ];
                }
                {
                  type = "releases";
                  cache = "1d";
                  repositories = ["glanceapp/glance" "go-gitea/gitea" "immich-app/immich" "syncthing/syncthing"];
                }
              ];
            }
          ];
        }
      ];
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
