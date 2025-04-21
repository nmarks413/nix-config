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

    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls?rev=a26718049a8657d4da04c331aeced1697bc7652b";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      inputs.nh.overlays.default
      #Signal desktop decided to break bc of being outdated on macos :(
      (
        final: prev: {
          signal-desktop-bin = prev.signal-desktop-bin.overrideAttrs (old: {
            version = "7.51.0";

            src = prev.fetchurl {
              url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-7.51.0.dmg";
              hash = "sha256-dUcBvKbGVsEUxOSv8u/jjuvYjHar2+zbv+/ZRS85w1w=";
            };
          });
        }
      )
    ];

    # ----- USER SETTINGS ----- #
    userSettings = rec {
      username = "nmarks"; # username
      name = "Natalie"; # name/identifier
      email = "nmarks413@gmail.com"; # email (used for certain configurations)
      dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
      theme = "catppuccin-mocha"; #name of theme that stylix will use
      browser = "firefox"; # Default browser; must select one from ./user/app/browser/
      term = "ghostty"; # Default terminal command;
      font = "iosevka"; # Selected font
      editor = "neovim"; # Default editor;
      spawnEditor = "exec" + term + " -e " + editor;
      timeZone = "America/Los_Angeles";
      sexuality = "bisexual";

      darwinHost = "laptop";
      nixosHost = "desktop";
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
