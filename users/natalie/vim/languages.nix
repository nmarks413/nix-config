{flake, ...}: {
  vim = {
    lsp.servers.nixd.settings = {
      nixd.nixpkgs.expr = "import '${flake.inputs.nixpkgs}' { }";
    };
    languages = {
      enableDAP = true;
      haskell.enable = true;
      lua.enable = true;
      python.enable = true;
      python.format.type = "ruff";
      # markdown.extensions.markview-nvim = {
      #   enable = true;
      #   setupOpts = {
      #   };
      # };
      nix = {
        lsp = {
          server = "nixd";
          options = {
            nixos = {
              expr = "(let
                  pkgs = import '${flake.inputs.nixpkgs}' {};
                  inherit (pkgs) lib;
                in (lib.evalModules {
                  modules = import '${flake.inputs.nixpkgs}/nixos/modules/module-list.nix';
                  check = false;
                })).options";
            };
            nix_darwin = {
              expr = "(let
                  pkgs = import ''${flake.inputs.nixpkgs}' {};
                  inherit (pkgs) lib;
                in (lib.evalModules {
                  modules = import '${flake.inputs.darwin}/modules/module-list.nix';
                  check = false;
                })).options";
            };
            home_manager = {
              expr = "(let
                  pkgs = import '${flake.inputs.nixpkgs}' {};
                  lib = import '${flake.inputs.home-manager}/modules/lib/stdlib-extended.nix' pkgs.lib;
                in (lib.evalModules {
                  modules = (import '${flake.inputs.home-manager}/modules/modules.nix') {
                    inherit lib pkgs;
                    check = false;
                  };
                })).options";
            };
          };
        };
      };
    };
    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft = {
          fish = ["fish_indent"];
          tex = ["latexindent"];
        };
      };
    };

    diagnostics.nvim-lint = {
      enable = true;
      linters_by_ft = {
        nix = ["statix"];
        tex = ["chktex"];
        haskell = ["hlint"];
      };
    };
  };
}
