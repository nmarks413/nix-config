{
  description = "New Modular flake!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
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

    # foundryvtt.url = "github:reckenrode/nix-foundryvtt";

    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh_darwin = {
      url = "github:ToyVo/nh_darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-options-search = {
      url = "github:madsbv/nix-options-search";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nix-options-search,
    home-manager,
    darwin,
    hosts,
    hyprland-plugins,
    zig,
    zls,
    ghostty,
    nixos-cosmic,
    nh_darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  } @ inputs: let
    overlays = [
      inputs.zig.overlays.default
    ];
    inherit (nixpkgs) lib;
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        modules = [
          {nixpkgs.overlays = overlays;}
          hosts.nixosModule
          {
            networking.stevenBlackHosts.enable = true;
          }
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.nmarks = import ./hosts/desktop/home.nix;
            };
            home-manager.extraSpecialArgs = {
              inherit hyprland-plugins;
              inherit zls;
              inherit ghostty;
            };
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
    darwinConfigurations = {
      "Natalies-MacBook-Air" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "yourname";

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
            };
          }
          # nh_darwin.nixDarwinModules.default
          {nixpkgs.overlays = overlays;}
          ./hosts/laptop/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.nmarks = import ./hosts/laptop/home.nix;
            };
            home-manager.extraSpecialArgs = {
              inherit zls;
              inherit ghostty;
            };
            users.users.nmarks.home = "/Users/nmarks";
          }
        ];
        specialArgs = {
          inherit nh_darwin;
          inherit inputs;
          inherit ghostty;
        };
      };
    };

    # darwinPackages = self.darwinConfigurations."Natalie-MacBook-Air".pkgs;
    # nixos = inputs.self.nixosConfigurations.nmarks;
    #
    #
    # nmarks = inputs.self.nixosConfigurations.nmarks.config.system.build.toplevel;
    # defaultPackage.x86_64-linux = inputs.self.nixosConfigurations.laptoptop.config.system.build.toplevel;
  };
}
