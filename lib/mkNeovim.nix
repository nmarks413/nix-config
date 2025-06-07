{
  nixpkgs,
  # TODO: apply overlays here
  overlays,
  inputs,
}:
configPath: system:
let
  darwin = nixpkgs.lib.strings.hasSuffix "-darwin" system;
  user = builtins.elemAt (builtins.split "/" configPath) 0;

  host = {
    inherit darwin;
    linux = !darwin;
  };

  userDir = ../users + "/${user}";
  userConfig = import (userDir + "/user.nix");
in
(inputs.nvf.lib.neovimConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  modules = builtins.filter (f: f != null) [
    (../users + ("/" + configPath + "/vim.nix"))
    ../modules/neovim
  ];
  extraSpecialArgs = {
    inherit host;
    user = userConfig;
  };
}).neovim
