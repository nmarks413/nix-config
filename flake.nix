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
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    ghostty,
    nixos-cosmic,
    ...
  } @ inputs: let
    overlays = [
      inputs.zig.overlays.default
    ];
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
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = systemSettings.system;
        modules = [
          nixos-cosmic.nixosModules.default
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
	  	home-manager.useUserPackages = true;
	    home-manager.users.nmarks = import ./hosts/desktop/home.nix;	
	    home-manager.extraSpecialArgs = {
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
          inherit stylix;
          inherit hyprland-plugins;
          inherit zls;
          inherit ghostty;
        };
          }
        ];
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
    darwinSystem = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nmarks = import ./hosts/laptop/home.nix;
            users.users.nmarks.home = "/Users/nmarks";
          };
        ];
        specialArgs = { inherit nixpkgs; };
   };
    # nixos = inputs.self.nixosConfigurations.nmarks;
    #
    #
    # nmarks = inputs.self.nixosConfigurations.nmarks.config.system.build.toplevel;
    # defaultPackage.x86_64-linux = inputs.self.nixosConfigurations.laptoptop.config.system.build.toplevel;
  };
}
