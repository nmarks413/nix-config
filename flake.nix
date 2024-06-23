{
  description = "New Modular flake!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      #flake = false;
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
      #flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";

    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls?rev=a26718049a8657d4da04c331aeced1697bc7652b";

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    stylix,
    blocklist-hosts,
    hyprland-plugins,
    zig,
    zls,
    ...
  } @ inputs: let
    overlays = [
      inputs.zig.overlays.default
    ];
    systemSettings = {
      system = "x86_64-linux"; # system arch
      hostname = "nixos"; # hostname
      #profile = "personal"; # select a profile defined from my profiles directory
      timezone = "America/Los_Angeles"; # select timezone
      locale = "en_US.UTF-8"; # select locale
    };
    userSettings = rec {
      username = "nmarks"; # username
      name = "Nmarks"; # name/identifier
      email = "nmarks413@gmail.com"; # email (used for certain configurations)
      dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
      #theme = "uwunicorn-yt"; # selcted theme from my themes directory (./themes/)
      wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
      # window manager type (hyprland or x11) translator
      wmType =
        if (wm == "hyprland")
        then "wayland"
        else "x11";
      browser = "firefox"; # Default browser; must select one from ./user/app/browser/
      term = "kitty"; # Default terminal command;
      font = ""; # Selected font
      fontPkg = pkgs.intel-one-mono; # Font package
      editor = "nvim"; # Default editor;
      # editor spawning translator
      # generates a command that can be used to spawn editor inside a gui
      # EDITOR and TERM session variables must be set in home.nix or other module
      # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
      spawnEditor =
        if (editor == "emacsclient")
        then "emacsclient -c -a 'emacs'"
        else
          (
            if ((editor == "vim") || (editor == "nvim") || (editor == "nano"))
            then "exec " + term + " -e " + editor
            else editor
          );
    };
    pkgs = import nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = overlays;
    };

    pkgs-stable = import nixpkgs-stable {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = [];
    };

    lib = nixpkgs.lib;
  in {
    homeConfigurations = {
      nmarks = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
          inherit stylix;
          inherit hyprland-plugins;
          inherit zls;
        };
      };
    };
    nixosConfigurations = {
      nmarks = lib.nixosSystem {
        system = systemSettings.system;
        modules = [./configuration.nix];
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
          inherit stylix;
          inherit blocklist-hosts;
        };
      };
    };
  };
}
