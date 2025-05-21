{
  flake,
  user,
  host,
  pkgs,
  ...
}: let
  darwin =
    if host.darwin
    then "darwin"
    else "nixos";
  flakePath = "/${
    if host.darwin
    then "Users"
    else "home"
  }/${user.username}/.dotfiles";

  # BIG HACK DO NOT DO PLS

  hostname =
    if host.darwin
    then "Natalies-MacBook-Air"
    else "nixos";
in {
  vim = {
    extraPackages = with pkgs; [
      python312Packages.pylatexenc
    ];
    lsp = {
      lightbulb.enable = false;
      lspsaga = {
        enable = true;
        setupOpts = {
          lightbulb = {
            virtual_text = false;
          };
        };
      };
      nvim-docs-view.enable = true;
      inlayHints.enable = true;
      servers.nixd.settings.nixd = {
        nixpkgs.expr = ''import "<nixpkgs>" { }'';
        options =
          {
            home-manager = {
              expr = ''(builtins.getFlake "${flakePath}").${darwin}Configurations.${hostname}.options.home-manager.users.type.getSubOptions [ ]'';
            };
          }
          // pkgs.lib.optionalAttrs host.darwin {
            nix-darwin = {
              expr = ''(builtins.getFlake "${flakePath}").darwinConfigurations.${hostname}.options'';
            };
          }
          // pkgs.lib.optionalAttrs host.linux {
            nixos = {
              expr = ''(builtins.getFlake "${flakePath}").nixosConfigurations.${hostname}.options'';
            };
          };
      };
      mappings = {
        codeAction = "<leader>ca";
        goToDeclaration = "gD";
        goToDefinition = "gd";
        listReferences = "gr";
        goToType = "gy";
        hover = null;
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
    languages = {
      enableDAP = true;
      lua.enable = true;
      python.enable = true;
      python.format.type = "ruff";
      markdown = {
        enable = true;
        extensions.render-markdown-nvim = {
          enable = true;
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
    treesitter = {
      enable = true;
      fold = true;
      addDefaultGrammars = true;
      highlight = {
        additionalVimRegexHighlighting = true;
      };

      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        markdown_inline
        markdown
      ];

      highlight.enable = true;
      indent.enable = false;
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
      mappings = {
        close = null;
        complete = null;
        confirm = null;
        next = null;
        previous = null;
        scrollDocsDown = null;
        scrollDocsUp = null;
      };

      setupOpts = {
        keymap = {
          preset = "super-tab";
        };
        completion = {
          ghost_text.enabled = false;
          list.selection.preselect = true;
          trigger = {
            show_in_snippet = true;
          };
          accept.auto_brackets.enabled = true;
        };
        signature = {
          enabled = true;
        };
      };
    };
  };
}
