{
  flake,
  userConfig,
  pkgs,
  ...
}: {
  vim = {
    extraPackages = with pkgs; [
      python312Packages.pylatexenc
    ];
    lsp = {
      nvim-docs-view.enable = true;
      inlayHints.enable = true;
      servers.nixd.settings = {
        nixd.nixpkgs.expr = ''import "${flake.inputs.nixpkgs}" { }'';
        options = {
          nixos = {
            expr = ''
              (let pkgs = import "${flake.inputs.nixpkgs}" {}; inherit (pkgs) lib; in (lib.evalModules { modules = (import "${flake.inputs.nixpkgs}/nixos/modules/module-list.nix"); check = false;})).options'';
          };
          nix_darwin = {
            expr = ''
              (let pkgs = import "${flake.inputs.nixpkgs}" {}; inherit (pkgs) lib; in (lib.evalModules { modules = import ("${flake.inputs.darwin}/modules/module-list.nix"); check = false;})).options'';
          };
          home_manager = {
            expr = ''
              (let pkgs = import "${flake.inputs.nixpkgs}" {}; lib = import "${flake.inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs.lib; in (lib.evalModules { modules = (import "${flake.inputs.home-manager}/modules/modules.nix") { inherit lib pkgs; check = false; };})).options'';
          };
        };
        mappings = {
          codeAction = "<leader>ca";
          goToDeclaration = "gD";
          goToDefinition = "gd";
          listReferences = "gr";
          goToType = "gy";
          hover = "K";
          nextDiagnostic = "<leader>d";
          openDiagnosticFloat = "<leader>df";
          renameSymbol = "rn";
          documentHighlight = null;
          listDocumentSymbols = null;
          listImplementations = null;
          listWorkspaceFolders = null;
          previousDiagnostic = null;
          removeWorkspaceFolder = null;
          signatureHelp = null;
          toggleFormatOnSave = null;
        };
      };
    };
    languages = {
      enableDAP = true;
      # haskell.enable = true;
      lua.enable = true;
      python.enable = true;
      python.format.type = "ruff";
      markdown.extensions.render-markdown-nvim = {
        enable = true;
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
    treesitter = {
      enable = true;
      fold = true;
      addDefaultGrammars = true;
      highlight = {
        additionalVimRegexHighlighting = true;
      };

      context.enable = true;
      highlight.enable = true;
      indent.enable = true;
    };

    visuals = {
      fidget-nvim = {
        setupOpts = {
          logger.level = "trace";
        };
      };
    };
    autocomplete.blink-cmp = {
      enable = true;
      # mappings = {
      # };

      setupOpts = {
        completion = {
          ghost_text.enabled = false;
          list.selection.preselect = true;
        };
      };
    };
  };
}
