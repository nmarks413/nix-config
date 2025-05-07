{
  description = "New Modular flake!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
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

    mkSystem = import ./lib/mkSystem.nix {
      inherit overlays nixpkgs inputs;
    };
  in rec {
    # "nix run .#darwin-rebuild"
    packages.aarch64-darwin.darwin-rebuild = darwin.packages.aarch64-darwin.darwin-rebuild;
    # "nix fmt ."
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;

    # natalie's desktop computer
    nixosConfigurations.nixos = mkSystem "nixos" {
      user = "natalie";
      host = "desktop";
      system = "x86_64-linux";
      extraModules = [
        nixos-cosmic.nixosModules.default
      ];
    };
    # natalie's laptop
    darwinConfigurations."Natalies-MacBook-Air" = mkSystem "Natalies-MacBook-Air" {
      user = "natalie";
      host = "laptop";
      system = "aarch64-darwin";
    };

    # chloe's mac studio "sandwich"
    darwinConfigurations.sandwich = mkSystem "sandwich" {
      user = "chloe";
      host = "sandwich";
      system = "aarch64-darwin";
    };
    # chloe's macbook air "paperback"
    darwinConfigurations.paperback = mkSystem "paperback" {
      user = "chloe";
      host = "paperback";
      system = "aarch64-darwin";
    };

    # generate checks for "nix flake check --all-systems --no-build"
    checks.aarch64-darwin = builtins.listToAttrs (builtins.map (name: let
      d = darwinConfigurations.${name}.system;
    in {
      name = "darwinConfiguration-" + d.name;
      value = d;
    }) (builtins.attrNames darwinConfigurations));
  };
}
