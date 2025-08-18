{ self, inputs }:
user: pkgs:
let
  darwin = pkgs.lib.strings.hasSuffix "-darwin" pkgs.system;

  host = {
    inherit darwin;
    linux = !darwin;
  };

  userDir = ../users + "/${user}";
  userConfig = import (userDir + "/user.nix");
in
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = builtins.filter (f: f != null) [
    (../users + ("/" + user + "/vim.nix"))
    ../modules/neovim
  ];
  extraSpecialArgs = {
    inherit host;
    flake = self;
    user = userConfig;
  };
}).neovim
