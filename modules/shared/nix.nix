{ inputs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  nix = {
    # nixPath = ["nixpkgs = ${inputs.nixpkgs}"];
    extraOptions = ''
      warn-dirty = false
    '';
    channel.enable = false;

    optimise = {
      automatic = true;
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      substituters = [
        "https://cache.nixos.org/?priority=10"

        "https://nix-community.cachix.org"
        # For haskell
        "https://cache.iog.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # For haskell
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
