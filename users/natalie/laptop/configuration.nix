{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pinentry_mac
    signal-desktop-bin
  ];

  # Custom configuration modules in "modules" are shared between users,
  # and can be configured in this "shared" namespace
  shared.darwin = {
    macAppStoreApps = [ "wireguard" ];
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true; # default shell on catalina
  };

  # When opening an interactive shell that isnt fish move into fish
  programs.zsh = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps -p $PPID -o comm) != "fish" && -z ''${ZSH_EXUCTION_STRING} ]]
      then
        [[ -o login ]] && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Use homebrew to install casks
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      upgrade = true;
    };

    brews = [
      "imagemagick"
      "opam"
    ];

    casks = [
      "battle-net"
      "stremio"
      "alt-tab"
      "legcord"
      "zulip"
      "zen-browser"
      "supertuxkart"
    ];
  };
}
