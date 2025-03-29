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

    # foundryvtt.url = "github:reckenrode/nix-foundryvtt";

    moonlight = {
      url = "github:moonlight-mod/moonlight"; # Add `/develop` to the flake URL to use nightly.
      inputs.nixpkgs.follows = "nixpkgs";
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

    chinese-fonts-overlay = {
      url = "github:brsvh/chinese-fonts-overlay/main";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nixos-cosmic,
    nh_darwin,
    ...
  } @ inputs: let
    overlays = [
      inputs.zig.overlays.default
      inputs.rust-overlay.overlays.default
      inputs.chinese-fonts-overlay.overlays.default
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
            };
          }
          nixos-cosmic.nixosModules.default
        ];
        specialArgs = inputs;
      };
    };
    darwinConfigurations = {
      "Natalies-MacBook-Air" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
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
            };
            users.users.nmarks.home = "/Users/nmarks";
          }
        ];
        specialArgs = {
          inherit nh_darwin;
          inherit inputs;
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
