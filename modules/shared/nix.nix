{ inputs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    nixPath = [ "nixpkgs = ${inputs.nixpkgs}" ];
    extraOptions = ''
      warn-dirty = false
    '';

    optimise = {
      automatic = true;
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org/?priority=10"

        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org/"
        # For haskell
        "https://cache.iog.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
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
