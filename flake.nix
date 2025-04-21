{
  description = "New Modular flake!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hosts = {
      url = "github:StevenBlack/hosts";
      #flake = false;
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
      #flake = false;
    };

    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls?rev=a26718049a8657d4da04c331aeced1697bc7652b";

    moonlight = {
      url = "github:moonlight-mod/moonlight"; # Add `/develop` to the flake URL to use nightly.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-options-search = {
      url = "github:madsbv/nix-options-search";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    chinese-fonts-overlay = {
      url = "github:brsvh/chinese-fonts-overlay/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    nixos-cosmic,
    nix-index-database,
    darwin,
    ...
  } @ inputs: let
    overlays = [
      inputs.zig.overlays.default
      inputs.rust-overlay.overlays.default
      inputs.chinese-fonts-overlay.overlays.default
      inputs.nh.overlays.default
    ];

    # ----- USER SETTINGS ----- #
    userSettings = rec {
      username = "nmarks"; # username
      name = "Natalie"; # name/identifier
      email = "nmarks413@gmail.com"; # email (used for certain configurations)
      dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
      browser = "firefox"; # Default browser; must select one from ./user/app/browser/
      term = "ghostty"; # Default terminal command;
      font = "iosevka Nerd Font"; # Selected font
      editor = "neovim"; # Default editor;
      spawnEditor = "exec" + term + " -e " + editor;
      timeZone = "America/Los_Angeles";
      sexuality = "bisexual";
    };

    mkSystem = import ./lib/mkSystem.nix {
      inherit overlays nixpkgs inputs userSettings;
    };
  in {
    nixosConfigurations.nixos = mkSystem "nixos" {
      system = "x86_64-linux";
      extraModules = [
        nixos-cosmic.nixosModules.default
      ];
    };
    darwinConfigurations."Natalies-MacBook-Air" = mkSystem "Natalies-MacBook-Air" {
      system = "aarch64-darwin";
      darwin = true;
    };
  };
}
