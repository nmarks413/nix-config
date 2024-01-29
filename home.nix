{
  inputs,
  config,
  pkgs,
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    stylua
    webcord
    btop
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
    rustup
    file
    #zsh-autosuggestions
    #zsh-autocomplete
    #zsh-powerlevel10k
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # for cmpm17
    binwalk
    #for fun
    cowsay
    cmatrix
    hyfetch
    bat
    eza
    ollama

    #LSP + formatters/linters
    lua-language-server
    nil
    alejandra
    statix
    texlab
    typst-fmt
    typst-lsp
  ];

  programs.direnv = {
    enable = true;
    #enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
    ];
  };
  #Link neovim config into nix
  #xdg.configFile.nvim.source = ./nvim;

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    extraConfig = "font_family Iosevka NF
                   italic_font auto
                   bold_italic_font  auto
                   bold_font  auto";
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
      hm-update = "git add home.nix ; git commit -m 'updated home-manager config'; git push origin main; home-manager switch --flake ~/.dotfiles/#nmarks";
      sys-update = "git add configuration.nix ; git commit -m 'updated system config'; git push origin main; sudo nixos-rebuild switch --flake ~/.dotfiles/#nmarks";
      full-update = "sys-update; hm-update";
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
    TERMINAL = "kitty";
    BROWSER = "firefox";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
