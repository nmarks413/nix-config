{
  description = "multi device configuration flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    apple-fonts.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf/v0.8";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls?rev=a26718049a8657d4da04c331aeced1697bc7652b";

    moonlight.url = "github:moonlight-mod/moonlight"; # Add `/develop` to the flake URL to use nightly.
    moonlight.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/stable";
      inputs.nixpkgs.follows = "nixpkgs";

    };

    nix-options-search.url = "github:madsbv/nix-options-search";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      darwin,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      overlays = [
        inputs.zig.overlays.default
        inputs.rust-overlay.overlays.default
        inputs.android-nixpkgs.overlays.default

        # https://github.com/LnL7/nix-darwin/issues/1041
        (_: prev: {
          karabiner-elements = prev.karabiner-elements.overrideAttrs (old: {
            version = "14.13.0";

            src = prev.fetchurl {
              inherit (old.src) url;
              hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
            };
          });
        })

        # custom packages
        (_: pkgs: {
          autofmt = pkgs.callPackage ./packages/autofmt.nix { };
        })
      ];

      # We only use x86_64 on Linux and Apple Silicon Macs
      # Overlays are applied here, as early as possible.
      getNixPkgs = system: import nixpkgs { inherit system overlays; };
      systems = {
        "x86_64-linux" = getNixPkgs "x86_64-linux";
        "aarch64-darwin" = getNixPkgs "aarch64-darwin";
      };
      forAllSystems =
        f:
        builtins.mapAttrs # #
          (system: pkgs: f (inputs // { inherit system pkgs; }))
          systems;

      # Library Functions
      mkNeovim = import ./lib/mkNeovim.nix { inherit self inputs; };
      mkSystem = import ./lib/mkSystem.nix { inherit inputs mkNeovim overlays; };
    in
    rec {
      inherit self;
      # "nix fmt"
      formatter = forAllSystems (inputs: inputs.pkgs.autofmt);
      packages = forAllSystems (
        { system, pkgs, ... }:
        {
          nvim-chloe = mkNeovim "chloe" pkgs;
          nvim-natalie = mkNeovim "natalie" pkgs;
          nvim-julia = mkNeovim "julia" pkgs;

          inherit (pkgs) autofmt;
        }
        // lib.optionalAttrs (system == "aarch64-darwin") {
          # "nix run .#darwin-rebuild"
          inherit (darwin.packages.aarch64-darwin) darwin-rebuild;
        }
      );

      # natalie's desktop computer
      nixosConfigurations.nixos = mkSystem "nixos" {
        user = "natalie";
        host = "desktop";
        system = "x86_64-linux";
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

      # julia's cattop
      nixosConfigurations.cattop = mkSystem "cattop" {
        user = "julia";
        host = "cattop";
        system = "x86_64-linux";
      };

      # generate checks for "nix flake check --all-systems --no-build"
      checks.aarch64-darwin = builtins.listToAttrs (
        builtins.map (
          name:
          let
            d = darwinConfigurations.${name}.system;
          in
          {
            name = "darwinConfiguration-" + d.name;
            value = d;
          }
        ) (builtins.attrNames darwinConfigurations)
      );
    };
}
