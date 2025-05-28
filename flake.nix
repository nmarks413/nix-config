{
  description = "multi device configuration flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    apple-fonts.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls?rev=a26718049a8657d4da04c331aeced1697bc7652b";

    moonlight.url = "github:moonlight-mod/moonlight"; # Add `/develop` to the flake URL to use nightly.
    moonlight.inputs.nixpkgs.follows = "nixpkgs";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";

    nh.url = "github:viperML/nh";
    nh.inputs.nixpkgs.follows = "nixpkgs";

    nix-options-search.url = "github:madsbv/nix-options-search";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      lix-module,
      nixos-cosmic,
      darwin,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      # TODO: apply these overlays sooner and remove uses of legacyPackages elsewhere.
      overlays = [
        inputs.zig.overlays.default
        inputs.rust-overlay.overlays.default
        inputs.nh.overlays.default

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
      ];

      # Users of this flake currently use x86_64 Linux and Apple Silicon
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems =
        f:
        builtins.listToAttrs (
          builtins.map (system: {
            name = system;
            value = f (
              inputs
              // {
                inherit system;
                pkgs = nixpkgs.legacyPackages.${system};
              }
            );
          }) systems
        );

      mkSystem = import ./lib/mkSystem.nix {
        inherit
          overlays
          nixpkgs
          lix-module
          inputs
          mkNeovim
          ;
      };
      mkNeovim = import ./lib/mkNeovim.nix {
        inherit
          self
          overlays
          nixpkgs
          inputs
          ;
      };
    in
    rec {
      inherit self;
      # "nix fmt"
      formatter = forAllSystems (inputs: inputs.pkgs.nixfmt-tree);
      packages = forAllSystems (
        { system, ... }:
        {
          nvim-chloe = mkNeovim "chloe" system;
          nvim-natalie = mkNeovim "natalie" system;
        }
        // lib.optionalAttrs (system == "aarch64-darwin") {
          # "nix run .#darwin-rebuild"
          darwin-rebuild = darwin.packages.aarch64-darwin.darwin-rebuild;
        }
      );

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
